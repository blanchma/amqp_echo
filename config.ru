require 'bundler/setup'
Bundler.require

require 'dotenv'
Dotenv.load

require './api'
require './admin'
require_relative 'config/configuration'

map '/assets' do
  environment = Sprockets::Environment.new( File.expand_path(File.dirname(__FILE__)) )
  environment.js_compressor = :uglifier
  environment.append_path Bower.environment.directory
  #environment.append_path 'app/assets/javascripts'
  environment.append_path 'app/assets/stylesheets'
  #environment.unregister_postprocessor 'application/javascript', Sprockets::SafetyColons
  run environment
end

run Rack::Cascade.new([ Vienna, Api, Admin ])
