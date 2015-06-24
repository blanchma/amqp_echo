require "bunny"

class Publisher
  DEFAULT_TOPIC = "avi-on.bridge"

  attr_reader :connection, :channel, :routing_key, :publish

  def initialize(routing_key, channel=nil)
    if channel
      @channel = channel
    else
      @connection = Bunny.new(::Configuration.amqp_url)
      @connection.start
      @channel = @connection.create_channel
    end

    @routing_key = routing_key
  end

  def publish(msg)
    puts "[Publisher] Publish to #{@routing_key} on topic: #{DEFAULT_TOPIC}"
    exchange = @channel.topic(DEFAULT_TOPIC)
    exchange.publish(msg, routing_key: @routing_key, persistent: true)
  end

  def close
    @channel.close
    @connection.close
  end
end
