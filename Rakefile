require 'dotenv'
Dotenv.load

require 'json'
require 'httparty'

require './config/configuration'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file }

task :listen do
  Echo.new.start
  EncryptedEcho.new.start
  sleep
end

task :ping do
  response = HTTParty.post "#{ENV["HOST"]}/registration"
  puts "Response: #{response.body}"
  body = JSON.parse(response.body)

  amqp_url = body["registration"]["url"]
  topic    = body["registration"]["topic"]
  queue    = body["registration"]["queue"]


  connection = Bunny.new(amqp_url)
  connection.start

  channel = connection.create_channel
  exchange = channel.topic(topic, durable: true)
  exchange.publish("ping", {routing_key: "#{queue}.out", persistent: true})
end

task :echo do
  connection = Bunny.new(Configuration.amqp_url)
  connection.start
  channel = connection.create_channel
  exchange = channel.topic(::Configuration.topics[:echo], durable: true)

  queue = channel.queue("", {durable: true})
  queue.bind(exchange, routing_key: "bridge.*.in")

  begin
    puts "[Echo] Waiting for messages..."
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
