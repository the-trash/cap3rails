puts "Redis: try to run on port: <%= fetch :redis_port %>!"
$redis = Redis.new(:port => <%= fetch :redis_port %> )