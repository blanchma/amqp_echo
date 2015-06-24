require './config/configuration'
require './lib/suscriber'
require './lib/publisher'
require 'json'
require 'httparty'

task :listen do
  Suscriber.new.start
end

task :ping do
  response = HTTParty.post "http://localhost:9292/registration"
  puts "Response: #{response.body}"
  body = JSON.parse(response.body)

  amqp_url = body["registration"]["url"]
  topic    = body["registration"]["topic"]
  queue    = body["registration"]["queue"]


  connection = Bunny.new(amqp_url)
  connection.start

  channel = connection.create_channel
  exchange = channel.topic(topic)
  exchange.publish("ping", routing_key: "#{queue}.out", persistent: true)
end

task :echo do
  connection = Bunny.new(Configuration.amqp_url)
  connection.start
  channel = connection.create_channel
  exchange = channel.topic(Suscriber::DEFAULT_TOPIC)

  queue = channel.queue("", {exclusive: true, durable: true})
  queue.bind(exchange, routing_key: "bridge.*.in")

  begin
    queue.subscribe(block: true) do |delivery_info, properties, body|
      puts "[Echo] Message: #{body}"

      routing_key = delivery_info.routing_key
      puts "[Echo] Message coming from #{routing_key}"

      exit
    end

  rescue Interrupt => _
    channel.close
    connection.close
    puts "[Suscriber] Interrupted"
  end
end
