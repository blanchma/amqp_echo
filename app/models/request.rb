class Request < Ohm::Model
  attribute :body
  attribute :message_id
  attribute :device_mac_address
  reference :rab, :Rab
  index :device_mac_address
  index :message_id
end
