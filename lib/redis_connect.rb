class RedisConnect

  def initialize(app)
    @app = app
  end

  def call(env)
    puts "Redis connect to #{ENV["REDISCLOUD_URL"]}"
    redis_url = URI.parse(ENV["REDISCLOUD_URL"])
    $redis = Redis.new(url: redis_url)
    @app.call(env)
  end
end
