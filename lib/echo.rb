require "./lib/subscriber"

class Echo < Subscriber
  self.name  = Configuration.topics[:echo]
  self.topic = Configuration.topics[:echo]
  self.routing_key = "bridge.*.out"

  def start
    puts "[Echo] Start to listen to #{@routing_key} on topic: #{@topic}"

    @queue.subscribe(auto_delete: true) do |delivery_info, properties, body|
      puts "[Echo] Message: #{body}"

      queue_out = delivery_info.routing_key
      puts "[Echo]  Message coming from #{queue_out}"

      queue_in = queue_out[/.out/]=".in"

      puts "[Echo]  Message echo to #{queue_in}"

      @exchange.publish(body, routing_key: queue_in, persistent: true)

      puts "[Echo] Echo complete"
    end
  end

end
