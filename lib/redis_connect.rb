module RedisConnect

  def self.setup(app)
    #puts "Redis connect to #{ENV["REDISCLOUD_URL"]}"
    #redis_url = URI.parse(ENV["REDISCLOUD_URL"])
    Ohm.redis = Redic.new(ENV["REDISCLOUD_URL"])
  end
end
