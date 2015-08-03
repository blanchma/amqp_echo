require 'bundler/setup'
Bundler.require

require 'dotenv'
Dotenv.load

require './api'
require './admin'
require_relative 'config/configuration'

map '/assets' do
  environment = Sprockets::Environment.new( File.expand_path(File.dirname(__FILE__)) )
  puts environment.js_compressor = :uglifier
  environment.append_path 'assets/javascripts'
  environment.append_path 'assets/stylesheets'
  run environment
end

run Rack::Cascade.new([ Api, Admin ])
