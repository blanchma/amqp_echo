require File.expand_path("helper", File.dirname(__FILE__))


test "Subscriber.new" do
  assert_raise(NilClass) {
    subscriber = Subscriber.new("test_topic", "test_queue")
  }
end
