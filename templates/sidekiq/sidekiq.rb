<%
  redis_port = Configs.redis.port
  namespace  = Configs.sidekiq.namespace
%>
puts "Sidekiq: try to connect to redis on port: <%= redis_port %>!" 

Sidekiq.configure_server do |config|
  config.redis = {
    :url => "redis://localhost:<%= fetch :redis_port %>/12",
    :namespace => "<%= namespace %>"
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    :url => "redis://localhost:<%= fetch :redis_port %>/12",
    :namespace => "<%= namespace %>"
  }
end