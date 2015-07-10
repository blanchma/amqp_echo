require_relative '../config/configuration'
require_relative '../lib/subscriber'

require 'digest'
require 'fast_secure_compare/fast_secure_compare'

class EncryptedEcho < Subscriber
  self.topic = Configuration.topics[:encrypted_echo]
  self.queue_name = "bridge.out"

  def initialize
    super(self.class.topic, self.class.queue_name)
  end

  def start
    puts "[EncryptedEcho] Start to listen to #{@queue_name} on topic: #{@topic}"

    @queue.subscribe(auto_delete: true) do |delivery_info, properties, body|
      body = JSON.parse(body)
      puts "[EncryptedEcho] Message: #{body}"

      queue_out = delivery_info.routing_key
      puts "[EncryptedEcho]  Message coming from #{queue_out}"

      queue_in = queue_out[/.out/]=".in"

      queue = queue_out[/bridge.\d+/]
      queue_in = queue + ".in"

      registration = $redis.get queue

      if registration
        registration = JSON.parse(registration)

        secret_key = registration["secret_key"]

        puts "[EncryptedEcho] Secret key: #{secret_key}"

        signature = Digest::SHA256.hexdigest("---#{body["message"]}---#{secret_key}---")

        puts "[EncryptedEcho] Created signature: #{signature}"
        puts "[EncryptedEcho] Received signature: #{body["signature"]}"

        if FastSecureCompare.compare(signature, body["signature"])
          puts "[EncryptedEcho] Encrypted message echo to #{routing_key}"
          exchange.publish( {message: body["message"], signature: signature}.to_json,
                            {routing_key: queue_in, persistent: true})

        else
          puts "[EncryptedEcho] Error 403"
          exchange.publish( {error: {code: "403", message: "Signature not match"} }.to_json,
                            {routing_key: queue_in, persistent: true})
        end
      else
        puts "[EncryptedEcho] Error 404"
        exchange.publish( {error: {code: "404", message: "Registration not found"} }.to_json,
                          {routing_key: queue_in, persistent: true})
      end

      puts "[EncryptedEcho] Echo complete"
    end
  end

end
