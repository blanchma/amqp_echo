require 'bundler/setup'
Bundler.require

require 'dotenv'
Dotenv.load

puts "REDIS: #{ENV["REDISCLOUD_URL"]}"
require './config/configuration'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file }

Cuba.use RedisConnect

Cuba.define do

  on post do
    on "registration" do
      res["Content-Type"]="application/json"
      registration = Registration.create
      res.write registration.to_json
    end

  end
end
