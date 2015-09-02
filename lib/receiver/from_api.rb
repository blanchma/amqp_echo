module Receiver
  class FromRab < ::Subscriber

    self.topic = Configuration.topics[:bridge_v1]
    self.queue_name =  Configuration.queues[:bridge_in]

    def initialize
      super(self.class.topic, self.class.queue_name)
    end

    def start
      puts "[Receiver::FromApi] Start to listen to #{@queue_name} on topic: #{@topic}"

      @queue.subscribe(auto_delete: true) do |delivery_info, properties, body|
        puts "[Receiver::FromApi] Message: #{body}"

        command = Transpiler::Change.parse(body)

        #Message.create(message: body, direction: :received, created_at: Time.now.utc)
        #Sender::ToRab.send(body)
      end
    end
  end
end
