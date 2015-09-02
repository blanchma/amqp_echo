class Command
  class UpdateState

    def to_change
      {
      "action": "update",
      "type_of_object": data["object"]
      "created_at": data["created_at"],
      "location_avid": data["location_avid"],
      "data": {
        "state": data["state"],
        "avid": data["avid"],
        "location_avid": data["location_avid"] }
      }
    end

    # 00 0a 00 00 00 80 // write dimming a 1 device sin ACK valor 80 (127)
    def to_protocol_v1
      [Transpiler::ProtocolV1::AP_VERB_WRITE, #verb
       data["avid"],
       0,
       0,
       0,
       data["state"]
      ]
    end

    private

    def required_fields
      ["object", "created_at", "state", "avid", "location_avid"]
    end
  end
end
