module Configuration

  class << self
    def configuration
    end

    def amqp_url
      ENV["AMQP_URL"]
    end

    def amqp_config
      {host: ENV["AMQP_VHOST"],
       username: ENV["AMQP_USERNAME"],
       password: ENV["AMQP_PASSWORD"],
       vhost: "sadwrfzk"}
    end
  end

end
