
module Sender
  class ToRab
    include Singleton

    attr_reader :exchange

    def initialize
      channel = AmqpConnection.create_channel
      @exchange = channel.topic(Configuration.topics[:bridge_v1], durable: true)
    end


    def self.send(message)

      instance.exchange.on_return do |basic_return, properties, payload|
        puts "[Sender::ToRab] #{payload} was returned! reply_code = #{basic_return.reply_code}, reply_text = #{basic_return.reply_text}"
      end

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
