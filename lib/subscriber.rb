require_relative '../config/configuration'

#TODO: use a singleton connection to keep connections reduced to minimum

class Subscriber

  class << self
    attr_accessor :topic, :queue_name
  end

  attr_reader :connection, :channel, :exchange, :queue, :queue_name

  def initialize(topic=nil, queue_name=nil)
    @channel = AmqpConnection.create_channel

    @topic = topic || self.class.topic
    @queue_name = self.class.queue_name || queue_name

    declare_exchange
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

  def declare_exchange
    @exchange = @channel.topic(@topic, durable: true)
  end

  def bind_queue
    @queue = @channel.queue(@queue_name, durable: true)
  end
end
