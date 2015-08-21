class Rab < Ohm::Model
  #Bridge's data
  attribute :queue
  attribute :secret_key
  attribute :amqp_url

  #Rab's data
  attribute :mac_address
  attribute :user
  attribute :location
  collection :devices, :Device
  collection :messages, :Message

  index :queue

  def to_json(options={})
    self.attributes.to_json
  end
end
