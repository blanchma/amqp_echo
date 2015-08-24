class Message < Ohm::Model
  attribute :raw
  attribute :message_id
  attribute :device_avid
  attribute :direction

  reference :device, :Device
  reference :rab, :Rab
  reference :response, :Message

  index :device_avid

  def to_json(options={})
    self.attributes.merge(id: self.id).to_json
  end
end
