module Sender
  class ToRab
    include Singleton

    attr_reader :exchange

    def initialize
      channel = AmqpConnection.create_channel
      @exchange = channel.topic(Configuration.topics[:bridge_v1], durable: true)
    end


    def self.send(message)
      response = instance.exchange.publish(message.body,
                        headers: {"avi-on-sign" =>  message.signature},
                        routing_key: message.routing_key,
                        persistent: true)
      puts response
      message.sent_at = Time.now.utc
      message.save!
    end


  end
end
