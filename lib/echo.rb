require_relative '../config/configuration'
require_relative './subscriber'

class Echo < Subscriber
  self.topic  = Configuration.topics[:echo]
  self.queue_name = "bridge.out"

  def initialize
    super(self.class.topic, self.class.queue_name)
  end

  def start
    puts "[Echo] Start to listen to #{@quene_name} on topic: #{@topic}"

    @queue.subscribe(auto_delete: true) do |delivery_info, properties, body|
      puts "[Echo] Message: #{body}"

      queue_out = delivery_info.routing_key
      puts "[Echo]  Message coming from #{queue_out}"

      queue_in = queue_out.sub(/.out/, ".in")

      puts "[Echo]  Message echo to #{queue_in}"

      @exchange.publish(body, routing_key: queue_in, persistent: true)

      puts "[Echo] Echo complete"
    end
  end

end
