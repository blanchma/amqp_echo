class Message < Ohm::Model
  attribute :body
  attribute :message_id
  attribute :device_avid
  attribute :direction

  reference :device, :Device
  reference :rab, :Rab
  reference :response, :Message

  index :device_avid
end
