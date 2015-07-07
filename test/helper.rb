require 'bundler/setup'
Bundler.require
Dotenv.load

require_relative '../config/configuration'
require_relative '../api'

def assert_response(body, expected)
  arr = []
  body.each { |line| arr << line }

  flunk "#{arr.inspect} != #{expected.inspect}" unless arr == expected
  print "."
end
