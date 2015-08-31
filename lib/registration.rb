class Registration
  attr_reader :id, :password, :topic, :queue

  def self.create(params)
    registration = new

    Binder.new(registration.topic, registration.queue).execute
    if ENV['RACK_ENV'] == "development"
      GrantPermission.new(registration.id,
                          registration.password,
                          registration.topic,
                          registration.queue ).execute
    end

    puts "Store registration[#{registration.id}]: #{registration.to_json}"
    registration.save

    registration
  end

  def initialize(mac_address=nil)
    @id = "avi-on.rab.#{Time.now.to_i}"
    @queue = @id
    @password = SecureRandom.urlsafe_base64(12, false)
    @secret_key = SecureRandom.hex(64)
    @topic = Configuration.topics[:bridge_v1]
  end

  def amqp_url
    #{}"amqp://#{@id}:#{@password}:#{ENV['AMQP_HOST']}/#{ENV['AMQP_VHOST']}"
    Configuration.amqp_url
  end

  def attributes
    {topic: @topic,
     queue: @queue,
     secret_key: @secret_key,
     url: amqp_url }
  end

  def save
    Rab.create(queue: @queue,
               secret_key: @secret_key,
               amqp_url: amqp_url,
               created_at: Time.now.utc)
  end

  def to_json
    {registration: attributes}.to_json
  end

end
