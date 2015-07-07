require 'dotenv'
Dotenv.load

require_relative '../config/configuration'
require 'bunny'
require 'singleton'

class AmqpConnection
  include Singleton
  attr_reader :connection

  def initialize
    @connection = Bunny.new(::Configuration.amqp_url)
    @connection.start
  end

  def self.connection
    instance.connection
  end

  def self.create_channel
    instance.connection.create_channel
  end

end
