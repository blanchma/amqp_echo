class Device < Ohm::Model
  attribute :mac_address
  reference :rab, :Rab

  index :mac_address
end
