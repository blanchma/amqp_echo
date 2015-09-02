module Transpiler
  class Change

    # Examples
    # {
    #   "action": "update",
    #   "type_of_object": "device",
    #   "created_at": "2014-05-15T12:37:26-03:00",
    #   "location_avid": 1,
    #   "data": {
    #     "state": {name: "LIGHT", value: 1}
    #     "avid": 1,
    #     "location_avid": 1,
    #     "device_id": 1
    #   }
    # }

    def self.parse(change)
      common_data = extract_commons(change)

      case change["action"]
      when "update"
        data = change["data"]

        if data.include("state")
          Command::UpdateState.new(common_data.merge(state: data["state"]) )
        else
          raise "Not recognized change"
        end

      else
        raise "Not recognized change"
      end
    end

    def self.extract_commons(change)
      {object: change["type_of_object"],
       created_at: change["type_of_object"],
       location_avid: change["location_avid"]
       avid: change["data"]["avid"]}
    end
  end
end
