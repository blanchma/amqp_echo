class Rab < Ohm::Model
  #Bridge's data
  attribute :queue
  attribute :debug
  attribute :secret_key
  attribute :amqp_url
  attribute :created_at

  #Rab's data
  attribute :mac_address
  attribute :user_id
  attribute :location_id
  collection :devices, :Device
  collection :messages, :Message

  index :queue
  index :user_id

  def to_json(options={})
    self.attributes.merge(id: self.id).to_json
  end
end
