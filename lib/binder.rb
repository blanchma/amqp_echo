require_relative '../config/configuration'

class Binder
  attr_reader :connection

  def initialize(topic, queue_name)
    @channel = AmqpConnection.create_channel

    @topic = topic
    @queue_name = queue_name
  end

  def execute
    puts "[Binder] Topic: #{@topic}"
    puts "[Binder] Queue: #{@queue_name}"

    #Create exchange to handle routings to RABs
    exchange = @channel.topic(Configuration.topics[:bridge_v1], durable: true)

    #Bind Queue for inputs
    queue = @channel.queue(@queue_name, durable: true)
    puts queue.bind(exchange, routing_key: "#{@queue_name}.in")

    #Bind Queue for outputs
    queue = @channel.queue(Configuration.queues[:bridge_in], durable: true)
    puts queue.bind(exchange, routing_key: "#{@queue_name}.out")

    #@channel.close
  end


end
