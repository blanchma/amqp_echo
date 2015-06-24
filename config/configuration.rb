module Configuration

  class << self
    def configuration
    end

    def amqp_url
      "amqp://sadwrfzk:IAaOqvPAezja8E_oXPngLvNL9gp6GwQA@owl.rmq.cloudamqp.com/sadwrfzk"
    end

    def amqp_config
      {host: "owl.rmq.cloudamqp.com",
       username: "sadwrfzk",
       password: "IAaOqvPAezja8E_oXPngLvNL9gp6GwQA",
       vhost: "sadwrfzk"}
    end
  end

end
