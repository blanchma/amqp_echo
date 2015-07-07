require_relative '../config/configuration'

class Binder
  attr_reader :connection

  def initialize(topic, queue_name)
    @channel = AmqpConnection.create_channel

    @topic = topic
    @queue_name = queue_name
  end

  def execute
    #Bind Queue for inputs
    queue = @channel.queue(@queue_name, durable: true)
    queue.bind(@topic, routing_key: "#{@queue_name}.in")

    #Bind Queue for outputs
    queue = @channel.queue("bridge.out", durable: true)
    queue.bind(@topic, routing_key: "#{@queue_name}.out")
    
    @channel.close
  end


end
