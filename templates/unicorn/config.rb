rails_root = "<%= current_path %>"
pid_file   = "<%= fetch :web_server_pid  %>"
socket_file= "<%= fetch :web_server_sock %>"
log_file   = "<%= fetch :web_server_log  %>"
err_log    = "<%= fetch :web_server_err  %>"
old_pid    = pid_file + '.oldbin'

pid pid_file
preload_app true
stderr_path err_log
stdout_path log_file

timeout 20
listen socket_file, :backlog => 1024

working_directory rails_root
worker_processes <%= fetch :web_server_workers %>

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{ rails_root }/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end