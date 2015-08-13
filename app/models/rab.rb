class Rab < Ohm::Model
  #Bridge's data
  attribute :queue
  attribute :secret_key
  attribute :amqp_url

  #Rab's data
  attribute :user
  attribute :location
  collection :devices, :Device

  index :queue
end
