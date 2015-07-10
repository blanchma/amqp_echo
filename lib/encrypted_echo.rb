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
      puts "[EncryptedEcho] Message: #{body}"

      queue_out = delivery_info.routing_key
      puts "[EncryptedEcho]  Message coming from #{queue_out}"

      queue = queue_out[/bridge.\d+/]
      queue_in = queue + ".in"

      registration = $redis.get queue

      if registration
        registration = JSON.parse(registration)
        secret_key = registration["secret_key"]

        puts "[EncryptedEcho] Secret key: #{secret_key}"

        received_signature = properties.headers["avi-on-sign"]
        signature = Digest::SHA256.hexdigest("---#{body}---#{secret_key}---")

        puts "[EncryptedEcho] Created signature: #{signature}"
        puts "[EncryptedEcho] Received signature: #{received_signature}"

        if FastSecureCompare.compare(signature, received_signature)
          puts "[EncryptedEcho] Encrypted message echo to #{queue_in}"
          exchange.publish( body,
                            { routing_key: queue_in,
                              headers: {
                                "avi-on-sign" => signature,
                                "code" => "200"
                              },
                              persistent: true})
        else
          puts "[EncryptedEcho] Error 403"
          exchange.publish( "Signature not match",
                            { routing_key: queue_in,
                              headers: {
                                "avi-on-sign" => signature,
                                "code" => "403"
                              },
                              persistent: true})
        end
      else
        puts "[EncryptedEcho] Error 404"
        exchange.publish( "Registration not found",
                          { routing_key: queue_in,
                            headers: {
                              "avi-on-sign" => signature,
                              "code" => "404"
                            },
                            persistent: true})
      end

      puts "[EncryptedEcho] Echo complete"
    end
  end

end
