require 'bundler/setup'
Bundler.require(:default, :development)
Dotenv.load

require './config/configuration'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file }

redis_url = URI.parse(ENV["REDISCLOUD_URL"])
$redis = Redis.new(url: redis_url)

task :listen do
  #Echo.new.start
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

#TODO: pending to complete
namespace :js do
  environment = Sprockets::Environment.new( File.expand_path(File.dirname(__FILE__)) )
  environment.js_compressor = :uglifier
  environment.append_path 'assets/javascripts'
  environment.append_path 'assets/stylesheets'
  source_code = environment['app.coffee']

  desc 'compile CoffeeScript with Sprockets'
  task :compile do
    bundle_file = './build/js/app.bundle.js'
    File.open(bundle_file, 'w'){ |f| f.write(source_code) }
    puts "app.coffee -> #{bundle_file}"
  end

  desc 'compile and minify CoffeeScript with Sprockets'
  task :min do
    bundle_min = './dist/js/app.bundle.min.js'
    source_min = Uglifier.compile(source_code)
    File.open(bundle_min, 'w'){ |f| f.write(source_min) }
    puts "app.coffee -> #{bundle_min}"
  end
end

task :test do
  exec "cutest test/*.rb"
end

task :default => :test
