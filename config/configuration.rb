module Configuration

  class << self
    def configuration
    end

    def amqp_url
      ENV["AMQP_URL"]
    end

    def amqp_config
      {host: ENV["AMQP_HOST"],
       username: ENV["AMQP_USERNAME"],
       password: ENV["AMQP_PASSWORD"],
       vhost: ENV["AMQP_VHOST"]}
    end
  end

end
