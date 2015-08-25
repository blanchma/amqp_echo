module Configuration

  class << self
    def configuration
    end

    def topics
      {
        echo: "avi-on.bridge.echo",
        encrypted_echo: "avi-on.bridge.encrypt",
        bridge_v1: "avi-on.bridge.v1",
        api_v1: "avi-on.api.v1"
      }
    end

    def queues
      { bridge_in: "avi-on.bridge.in",
        api_out: "avi-on.api.out",
        api_in: "avi-on.api.in"
       }
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
