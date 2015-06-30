require './config/configuration'

class Subscriber

  class << self
    attr_accessor :routing_key, :topic
  end

  attr_reader :connection, :channel, :routing_key, :queue, :exchange

  def initialize(topic=nil, routing_key=nil)
    @connection = Bunny.new(::Configuration.amqp_url)
    @connection.start
    @topic = topic || self.class.topic
    @routing_key = routing_key || self.class.routing_key

    create_channel
    create_exchange
    bind_queue
  end

  def start(options={}, &block)
    puts "[Suscriber] Start to listen to #{@routing_key} on topic: #{@topic}"

    begin
      if block_given?
        @queue.subscribe(options, &block)
      else
        @queue
      end

    rescue Interrupt => _
      self.close
      puts "[Suscriber] Interrupted"
    end
  end

  def close
    puts "[Suscriber] Close connection"
    @channel.close
    @connection.close
  end

  private

  def create_channel
    @channel = @connection.create_channel
  end

  def create_exchange
    @exchange = @channel.topic(@topic, durable: true)
  end

  def bind_queue
    @queue = @channel.queue("", durable: true)
    @queue.bind(@exchange, routing_key: @routing_key)
  end
end
