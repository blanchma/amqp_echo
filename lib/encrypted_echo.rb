require "./lib/subscriber"

require 'base64'
require 'digest'

class EncryptedEcho < Subscriber
  self.topic = Configuration.topics[:encrypted_echo]
  self.routing_key = "bridge.*.out"

  def start
    puts "[EncryptedEcho] Start to listen to #{@routing_key} on topic: #{@topic}"

    @queue.subscribe do |delivery_info, properties, body|
      puts "[EncryptedEcho] Message: #{body}"

      routing_key = delivery_info.routing_key
      puts "[EncryptedEcho]  Message coming from #{routing_key}"

      routing_key[/.out/]=".in"

      puts "[EncryptedEcho] Message echo to #{routing_key}"
      signature = Digest::SHA256.hexdigest(body.message)

      if FastSecureCompare.compare(body.message, signature)
        exchange.publish({message: body.message, signature: signature}, {routing_key: routing_key, persistent: true})
      else
        exchange.publish({error: {code: "403", message: "signature not match"} }, {routing_key: routing_key, persistent: true})
      end

      puts "[EncryptedEcho] Echo complete"
    end
  end

end
