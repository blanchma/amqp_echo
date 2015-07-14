class Registration
  attr_reader :id, :password, :topic, :queue

  def self.create
    registration = new

    Binder.new(registration.topic, registration.queue).execute
    if ENV['RACK_ENV'] == "development"
      GrantPermission.new(registration.id,
                          registration.password,
                          registration.topic,
                          registration.queue ).execute
    end

    puts "Store registration[#{registration.id}]: #{registration.to_json}"
    $redis.set registration.id, registration.attributes.to_json

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
    "amqp://#{@id}:#{@password}:#{ENV['AMQP_HOST']}/#{ENV['AMQP_VHOST']}"
  end

  def attributes
    {topic: @topic,
     queue: @queue,
     secret_key: @secret_key,
     amqp_url: amqp_url }
  end

  def to_json
    {registration: attributes}.to_json
  end

end
