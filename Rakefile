require 'bundler/setup'
Bundler.require(:default, :development)
Dotenv.load

require './config/configuration'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file }

redis_url = URI.parse(ENV["REDISCLOUD_URL"])
$redis = Redis.new(url: redis_url)

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

  channel = AmqpConnection.create_channel
  exchange = channel.topic(topic, durable: true)
  exchange.publish("ping", {routing_key: "#{queue}.out", persistent: true})

  listen_echo = Subscriber.new(topic, queue)

  listen_echo.start(block: true) do |delivery_info, properties, body|
    routing_key = delivery_info.routing_key
    puts "[Echo] Message \"#{body}\" coming from #{routing_key}"

    channel.close
    exit
  end

end

task :encrypted_ping do
  response = HTTParty.post "#{ENV["HOST"]}/registration"
  puts "Response: #{response.body}"
  body = JSON.parse(response.body)

  amqp_url    = body["registration"]["url"]
  topic       = body["registration"]["encrypted_topic"]
  queue       = body["registration"]["queue"]
  secret_key  = body["registration"]["secret_key"]

  channel = AmqpConnection.create_channel
  exchange = channel.topic(topic, durable: true)

  signature = Digest::SHA256.hexdigest("---ping---#{secret_key}---")
  exchange.publish({message: "ping", signature:  signature}.to_json,
                   {routing_key: "#{queue}.out", persistent: true})

  listen_echo = Subscriber.new(topic, queue)

  listen_echo.start(block: true) do |delivery_info, properties, body|
    body = JSON.parse(body)
    puts "[EncryptedEcho] Message: #{body}"

    routing_key = delivery_info.routing_key
    puts "[EncryptedEcho] Message coming from #{routing_key}"

    queue = routing_key[/bridge.\d+/]

    registration = $redis.get queue

    if registration
      registration = JSON.parse(registration)

      secret_key = registration["secret_key"]

      signature = Digest::SHA256.hexdigest("---#{body["message"]}---#{secret_key}---")

      if FastSecureCompare.compare(body["signature"], signature)
        puts "[EncryptedEcho] SUCCESS: Signature and message match"
      else
        puts "[EncryptedEcho] ERROR: Signature and message NOT match"
      end
    else
      puts "[EncryptedEcho] ERROR: Registration not found"
    end
    channel.close
    exit
  end
end

task :test do
  exec "cutest test/*.rb"
end

task :default => :test
