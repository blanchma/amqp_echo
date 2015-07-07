#TODO: this should be also an unbind command for de-registration

class Binder
  attr_reader :connection

  def initialize(topic, queue_name)
    @connection = Bunny.new(::Configuration.amqp_url)
    @connection.start

    @topic = topic
    @queue_name = queue_name
    @routing_key = routing_key
  end

  def execute
    channel = @connection.create_channel
    exchange = channel.topic(@topic, durable: true)

    #Bind Queue for inputs
    queue = channel.queue(@queue_name, durable: true)
    queue.bind(exchange, routing_key: "#{@queue_name}.in")

    #Bind Queue for outputs
    queue = channel.queue("bridge.out", durable: true)
    queue.bind(exchange, routing_key: "#{@queue_name}.out")
  end


end
