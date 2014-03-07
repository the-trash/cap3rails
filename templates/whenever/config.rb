set :environment_variable, 'RAILS_ENV'
set :output, { :error => "<%= fetch :log_dir %>/cron.err.log", :standard => "<%= fetch :log_dir %>/cron.log" }

job_type :rake, "cd <%= current_path %> && <%= rvm_do %> bundle exec rake :task :environment_variable=:environment :output"

every 1.minute do
  rake 'test:crontab', environment: environment
end

every 10.minutes do
  rake 'ts:rebuild', environment: environment
end