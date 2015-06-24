class Registration
  def initialize(mac_address=nil)
  end

  def queue
    "bridge.#{Time.now.to_i}"
  end

  def to_json
    {registration: {url: Configuration.amqp_url, topic: Suscriber::DEFAULT_TOPIC, queue: "#{self.queue}" } }.to_json
  end
end
