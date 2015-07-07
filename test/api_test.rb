require File.expand_path("helper", File.dirname(__FILE__))
#mocks
def Time.now
  1
end

def SecureRandom.hex(x)
  "xxx"
end

test "POST /registration" do
  env = { "REQUEST_METHOD" => "POST", "PATH_INFO" => "/registration",
          "SCRIPT_NAME" => "/", "rack.input" => StringIO.new,
          "QUERY_STRING" => "email=john@doe.com" }

  _, _, resp = Cuba.call(env)

  assert_response resp, [{registration: { url: Configuration.amqp_url,
                          topic: Configuration.topics[:echo],
                          encrypted_topic: Configuration.topics[:encrypted_echo],
                          queue: "bridge.1",
                          secret_key: "xxx"} }.to_json]
end
