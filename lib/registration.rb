class Registration
  attr_reader :id, :password, :topic, :queue

  def self.create
    registration = new

    Binder.new(topic, registration.queue).execute
    GrantPermission.new(registration.id,
                        registration.password,
                        registration.topic,
                        registration.queue ).execute

    puts "Store registration[#{registration.id}]: #{registration.to_json}"
    $redis.set registration.id, registration.to_json

    registration
  end

  def initialize(mac_address=nil)
    @id = "bridge.#{Time.now.to_i}"
    @queue = @id
    @password = SecureRandom.urlsafe_base64(12, false)
    @secret_key = SecureRandom.hex(64)
    @topic = Configuration.topics[:echo]
  end

  def amqp_url
    "amqp://#{@id}:#{@password}:#{ENV['AMQP_HOST']}:#{ENV['AMQP_PORT']}/#{ENV['AMQP_VHOST']}"
  end

  def to_json
    {registration: {
      topic: @topic
      queue: @queue,
      secret_key: @secret_key,
      amqp_url: amqp_url}
    }.to_json
  end

end
