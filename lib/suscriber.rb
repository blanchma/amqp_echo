require "bunny"

class Suscriber
  DEFAULT_TOPIC = "avi-on.bridge"

  attr_reader :connection, :channel, :routing_key

  def initialize(routing_key="bridge.*.out")
    @connection = Bunny.new(::Configuration.amqp_url)
    @connection.start
    @channel   = @connection.create_channel
    @routing_key = routing_key
  end

  def start
    puts "[Suscriber] Start to listen to #{@routing_key} on topic: #{DEFAULT_TOPIC}"
    
    exchange    = @channel.topic(DEFAULT_TOPIC)

    queue = @channel.queue("", {exclusive: true, durable: true})

    queue.bind(exchange, routing_key: @routing_key)

    begin
      queue.subscribe(block: true) do |delivery_info, properties, body|
        puts "[Suscriber] Message: #{body}"

        routing_key = delivery_info.routing_key
        puts "[Suscriber]  Message coming from #{routing_key}"

        routing_key[/.out/]=".in"

        puts "[Suscriber]  Message echo to #{routing_key}"
        exchange.publish(body, routing_key: routing_key, persistent: true)

        puts "[Suscriber] Echo complete"
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

end
