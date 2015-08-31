require "cuba/safe"

require_relative 'config/configuration'
Dir[File.dirname(__FILE__) + '/lib/**/*.rb'].each{|file| require file }
Dir[File.dirname(__FILE__) + '/app/models/*.rb'].each{|file| require file }

Cuba.plugin RedisConnect

class Api < Cuba; end;

Api.define do
  on "api" do
    on post do
      on "registrations/:rab_id/messages" do |rab_id|
        res["Content-Type"]="application/json; charset=utf-8"
        puts req.params["bytes"]
        message = Message.new(rab_id: rab_id, body: req.params["bytes"], direction: "sent")
        message.save
        Sender::ToRab.send(message)
        res.status = 201
        res.write(message.to_json)
      end

      on "registrations" do
        res["Content-Type"]="application/json"
        registration = Registration.create(req.params)
        res.write registration.to_json
      end
    end

    on get do
      on "registrations/:rab_id/messages" do |rab_id|
        res["Content-Type"]="application/json; charset=utf-8"
        messages = Message.find(rab_id: rab_id).to_a
        res.write messages.to_json
      end

      on "registrations" do
        res["Content-Type"]="application/json; charset=utf-8"
        rabs = Rab.all.to_a
        res.write rabs.to_json
      end
    end
  end
end
