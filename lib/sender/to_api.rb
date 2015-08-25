module Sender
  class ToApi
    include Singleton

    attr_reader :exchange

    def initialize
      channel = AmqpConnection.create_channel
      @exchange = channel.topic(Configuration.topics[:api_v1], durable: true)
    end


    def self.send(message)
      #signature = Digest::SHA256.hexdigest("---ping---#{secret_key}---")
      instance.exchange.publish(message,
                        persistent: true)
    end
  end
end
