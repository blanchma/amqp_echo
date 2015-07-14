require_relative '../config/configuration'

class GrantPermission

  def initialize(user, password, topic, queue_name)
    @user = user
    @password = password
    @topic = topic
    @queue_name = queue_name
  end

  def execute
    puts "[GrantPermission] Grant #{@user} access to #{@queue_name} in topic '#{@topic}'"
    
    response = Typhoeus.put("#{ ENV["AMQP_HTTP_API"] }/api/users/#{ @user }",
                  userpwd: "#{ Configuration.amqp_config[:username] }:#{ Configuration.amqp_config[:password] }",
                  headers: { "Content-Type" => "application/json" },
                  body: { username: @user,
                          password: @password,
                          tags: ""}.to_json)

    if response.success?
      response = Typhoeus.put("#{ ENV["AMQP_HTTP_API"] }/api/#{Configuration.amqp_config[:vhost]}/#{ @user }",
                    userpwd: "#{ Configuration.amqp_config[:username] }:#{ Configuration.amqp_config[:password] }",
                    headers: { "Content-Type" => "application/json" },
                    body: { configure: "",
                            write: @topic,
                            read: @queue_name}.to_json)
      response.success?
    else
      false
    end

  end


end
