module RedisConnect

  def self.setup(app)
    puts "Redis connect to #{ENV["REDISCLOUD_URL"]}"
    redis_url = URI.parse(ENV["REDISCLOUD_URL"])
    $redis = Redis.new(url: redis_url)
  end
end
