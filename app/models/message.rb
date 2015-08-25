class Message < Ohm::Model
  attribute :body
  attribute :message_id
  attribute :device_avid
  attribute :direction #sent OR received
  attribute :created_at
  attribute :sent_at

  reference :device, :Device
  reference :rab, :Rab
  reference :response, :Message

  index :device_avid

  def to_json(options={})
    self.attributes.merge(id: self.id).to_json
  end

  def signature
    @signature ||= Digest::SHA256.hexdigest("---#{self.body}---#{self.rab.secret_key}---")
  end

  def routing_key
    "#{self.rab.queue}.in"
  end

  def save!
    save if rab.debug
  end

  def create(args)
    message = super

    if message.id
    else

    end
  end
end
