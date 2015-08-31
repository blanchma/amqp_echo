require 'bundler/setup'
Bundler.require(:default, :development)
Dotenv.load

require './config/configuration'
Dir[File.dirname(__FILE__) + '/lib/**/*.rb'].each{|file| require file }
Dir[File.dirname(__FILE__) + '/app/models/*.rb'].each{|file| require file }

$redis = Redic.new(ENV["REDISCLOUD_URL"])

task :seed do
  5.times {|i| Rab.create queue: "tute#{i}", mac_address: "127.0.0.#{i}", user_id: i, location_id: i }
  Rab.all.to_a.each {|r|
    10.times {|i| Message.create( rab_id: r.id,
                                  message_id: "id_#{i}",
                                  body: "body #{i}",
                                  direction: [:sent, :received].sample) }
  }

end

task :listen_from_rab do
  #Echo.new.start
  Receiver::FromRab.new.start
  sleep
end

task :inverted_ping do
  response = HTTParty.post "#{ENV["HOST"]}/api/registrations", body: {user_id: 1, location: 1}
  puts "Response: #{response.body}"
  body = JSON.parse(response.body)

  amqp_url    = body["registration"]["url"]
  topic       = body["registration"]["topic"]
  queue       = body["registration"]["queue"]
  secret_key  = body["registration"]["secret_key"]

  channel = Bunny.new(amqp_url).start.create_channel
  exchange = channel.topic(topic, durable: true)

  listen_echo = Subscriber.new(topic, queue)

  listen_echo.start(block: true) do |delivery_info, properties, body|
    puts "[InvertedPing] Message: #{body}"

    routing_key = delivery_info.routing_key
    puts "[InvertedPing] Message coming from #{routing_key}"

    signature = Digest::SHA256.hexdigest("---#{body}---#{secret_key}---")

    puts "[InvertedPing] Headers: #{properties.headers}"

    if FastSecureCompare.compare(properties.headers["avi-on-sign"], signature)
      puts "[InvertedPing] SUCCESS: Signature and message match"

        signature = Digest::SHA256.hexdigest("---#{body}---#{secret_key}---")
        exchange.publish(body,  headers: {"avi-on-sign" =>  signature},
                                  routing_key: "#{queue}.out",
                                  persistent: true)
    else
      puts "[InvertedPing] ERROR: Signature and message NOT match"
    end
  end

  at_exit do
    channel.close
  end
end

task :ping do
  response = HTTParty.post "#{ENV["HOST"]}/api/registrations"
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
  response = HTTParty.post "#{ENV["HOST"]}/api/registrations"
  puts "Response: #{response.body}"
  body = JSON.parse(response.body)

  amqp_url    = body["registration"]["url"]
  topic       = body["registration"]["topic"]
  queue       = body["registration"]["queue"]
  secret_key  = body["registration"]["secret_key"]

  channel = Bunny.new(amqp_url).start.create_channel
  exchange = channel.topic(topic, durable: true)

  signature = Digest::SHA256.hexdigest("---ping---#{secret_key}---")
  exchange.publish("ping",  headers: {"avi-on-sign" =>  signature},
                            routing_key: "#{queue}.out",
                            persistent: true)

  listen_echo = Subscriber.new(topic, queue)

  listen_echo.start(block: true) do |delivery_info, properties, body|
    puts "[EncryptedEcho] Message: #{body}"

    routing_key = delivery_info.routing_key
    puts "[EncryptedEcho] Message coming from #{routing_key}"

    signature = Digest::SHA256.hexdigest("---#{body}---#{secret_key}---")

    puts "HEADERS: #{properties.headers}"

    if FastSecureCompare.compare(properties.headers["avi-on-sign"], signature)
      puts "[EncryptedEcho] SUCCESS: Signature and message match"
    else
      puts "[EncryptedEcho] ERROR: Signature and message NOT match"
    end

    channel.close
    exit
  end
end

task :test do
  exec "cutest test/*.rb"
end

namespace :webpack do
  desc 'compile bundles using webpack'
  task :compile do
    cmd = 'webpack --config config/webpack/production.config.js --json'
    output = `#{cmd}`

    stats = JSON.parse(output)

    File.open('./public/assets/webpack-asset-manifest.json', 'w') do |f|
      f.write stats['assetsByChunkName'].to_json
    end
  end
end

task :default => :test
