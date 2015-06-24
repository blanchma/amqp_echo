require 'bundler/setup'
Bundler.require#(:default, PADRINO_ENV)
require 'dotenv'
Dotenv.load

require './config/configuration'
require './lib/registration'
require './lib/suscriber'

Cuba.define do
  on post do
    on "registration" do
      res["Content-Type"]="application/json"
      registration = Registration.new
      res.write registration.to_json
    end

  end
end
