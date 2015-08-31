5.times {|i| Rab.create queue: "tute#{i}", mac_address: "127.0.0.#{i}", user_id: i, location_id: i, debug: true }
Rab.all.to_a.each {|r| 10.times {|i| Message.create(rab_id: r.id, message_id: "id_#{i}", body: "body #{i}", direction: [:sent, :received].sample) } }
