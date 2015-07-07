require 'bundler/setup'
Bundler.require

require 'dotenv'
Dotenv.load

require_relative 'config/configuration'
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
