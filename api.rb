require "cuba/safe"

require_relative 'config/configuration'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file }

Cuba.plugin RedisConnect

class Api < Cuba; end;

Api.define do
  on post do
    on "registration" do
      res["Content-Type"]="application/json"
      registration = Registration.create
      res.write registration.to_json
    end
  end
end
