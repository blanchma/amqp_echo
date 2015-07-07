require './config/configuration'

class Subscriber

  class << self
    attr_accessor :topic, :queue_name
  end

  attr_reader :connection, :channel, :exchange, :queue, :queue_name

  def initialize(topic=nil, queue=nil)
    @connection = Bunny.new(::Configuration.amqp_url)
    @connection.start

    @topic = topic || self.class.topic
    @queue_name = self.class.queue || queue
    @routing_key = routing_key || self.class.routing_key

    create_channel
    create_exchange
    bind_queue
  end

  def start(options={}, &block)
    puts "[Suscriber] Start to listen to #{@queue_name} on topic: #{@topic}"

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
    @queue = @channel.queue(@queue_name, durable: true)
  end
end
