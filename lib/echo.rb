require "./lib/subscriber"

class Echo < Subscriber
  self.topic = Configuration.topics[:echo]
  self.routing_key = "bridge.*.out"

  def start
    puts "[Echo] Start to listen to #{@routing_key} on topic: #{@topic}"

    @queue.subscribe do |delivery_info, properties, body|
      puts "[Echo] Message: #{body}"

      routing_key = delivery_info.routing_key
      puts "[Echo]  Message coming from #{routing_key}"

      routing_key[/.out/]=".in"

      puts "[Echo]  Message echo to #{routing_key}"
      exchange.publish(body, {routing_key: routing_key, persistent: true})

      puts "[Echo] Echo complete"
    end
  end

end
