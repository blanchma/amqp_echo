class RedisConnect

  def initialize(app)
    @app = app
  end

  def call(env)
    redis_url = URI.parse(ENV["REDISCLOUD_URL"])
    $redis = Redis.new(uri: redis_url)
    @app.call(env) 
  end
end
