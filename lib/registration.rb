class Registration
  attr_reader :id, :attributes

  def self.create
    registration = new
    puts "Store registration[#{registration.id}]: #{registration.attributes}"
    $redis.set registration.id, registration.attributes.to_json
    Binder.new(Configuration.topics[:echo], self.id)
    Binder.new(Configuration.topics[:encrypted_echo], self.id)
    registration
  end

  def initialize(mac_address=nil)
    @attributes = { url: Configuration.amqp_url,
                    topic: Configuration.topics[:echo],
                    encrypted_topic: Configuration.topics[:encrypted_echo],
                    queue: self.id,
                    secret_key: self.secret_key}
  end

  def id
    @queue ||= "bridge.#{Time.now.to_i}"
  end

  def secret_key
    SecureRandom.hex(64)
  end

  def to_json
    {registration: @attributes}.to_json
  end
end
