
module Receiver
  class FromRab < Subscriber

    self.topic = Configuration.topics[:bridge_v1]
    self.queue_name =  Configuration.queues[:bridge_in]

    def initialize
      super(self.class.topic, self.class.queue_name)
    end

    def start
      puts "[Receiver::FromRab] Start to listen to #{@queue_name} on topic: #{@topic}"

      @queue.subscribe(block: true, auto_delete: true) do |delivery_info, properties, body|
        puts "[Receiver::FromRab] Message: #{body}"
        routing_key = delivery_info.routing_key
        queue = routing_key[/avi-on.rab.\d+/]
        # queue_in = queue + ".in"

        puts "[Receiver::FromRab]  Message coming from #{queue}"

        rab = Rab.find(queue: queue).first

        if rab
          secret_key = rab.secret_key

          puts "[Receiver::FromRab] Secret key: #{secret_key}"

          received_signature = properties.headers["avi-on-sign"]
          signature = Digest::SHA256.hexdigest("---#{body}---#{secret_key}---")

          puts "[Receiver::FromRab] Created signature: #{signature}"
          puts "[Receiver::FromRab] Received signature: #{received_signature}"

          if FastSecureCompare.compare(signature, received_signature)
            Message.create(rab_id: rab.id, body: body, direction: :received, created_at: Time.now.utc)

            #Sender::ToApi.send(body)
          else
            puts "[Receiver::FromRab] Error 403"
            # exchange.publish( "Signature not match",
            #                   { routing_key: queue_in,
            #                     headers: {
            #                       "avi-on-sign" => signature,
            #                       "code" => "403"
            #                     },
            #                     persistent: true})
          end
        else
          puts "[Receiver::FromRab] Error 404"
          # exchange.publish( "Registration not found",
          #                   { routing_key: queue_in,
          #                     headers: {
          #                       "avi-on-sign" => signature,
          #                       "code" => "404"
          #                     },
          #                     persistent: true})
        end
      end
    end
  end
end
