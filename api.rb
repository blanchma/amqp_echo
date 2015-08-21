require "cuba/safe"

require_relative 'config/configuration'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file }
Dir[File.dirname(__FILE__) + '/app/models/*.rb'].each{|file| require file }

Cuba.plugin RedisConnect

class Api < Cuba; end;

Api.define do
  on "api" do
    on post do
      on "registrations" do
        res["Content-Type"]="application/json"
        registration = Registration.create(params)
        res.write registration.to_json
      end
    end

    on get do
      on "registrations" do
      res["Content-Type"]="application/json; charset=utf-8"
        rabs = Rab.all.to_a
        res.write rabs.to_json
      end

    end
  end
end
