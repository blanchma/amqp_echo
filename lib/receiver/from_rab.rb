require 'configuration'

module Receiver
  class FromRab

    self.topic = Configuration.topic[:bridge_v1]
    self.queue_name =  Configuration.queues[:bridge_in]

    def initialize
      super(self.class.topic, self.class.queue_name)
    end

    def start
      puts "[Receiver::FromRab] Start to listen to #{@queue_name} on topic: #{@topic}"

      @queue.subscribe(auto_delete: true) do |delivery_info, properties, body|
        puts "[Receiver::FromRab] Message: #{body}"
        queue = delivery_info.routing_key
        puts "[Receiver::FromRab]  Message coming from #{queue_out}"

        //queue = queue_out[/bridge.\d+/]
        //queue_in = queue + ".in"

        rab = Rab.find(queue: queue)

        if rab
          secret_key = rab.secret_key

          puts "[Receiver::FromRab] Secret key: #{secret_key}"

          received_signature = properties.headers["avi-on-sign"]
          signature = Digest::SHA256.hexdigest("---#{body}---#{secret_key}---")

          puts "[Receiver::FromRab] Created signature: #{signature}"
          puts "[Receiver::FromRab] Received signature: #{received_signature}"

          if FastSecureCompare.compare(signature, received_signature)
            puts "[Receiver::FromRab] Encrypted message echo to #{queue_in}"

            Message.create(rab_id: rab.id, message: body, direction: :received, created_at: Time.now.utc)
            # exchange.publish( body,
            #                   { routing_key: queue_in,
            #                     headers: {
            #                       "avi-on-sign" => signature,
            #                       "code" => "200"
            #                     },
            #                     persistent: true})

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
