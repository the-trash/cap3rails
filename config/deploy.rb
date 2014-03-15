set :scm, :git
# set :pty, true

set :tmp_dir, "#{ Configs.deploy_to }/tmp_dir"
set :local_backups_dir, ((dir = Configs['local_backups_dir']) ? dir : '/tmp')

set :repo_url,      Configs.repo
set :branch,        Configs.branch
set :deploy_to,     Configs.deploy_to
set :keep_releases, Configs.keep_releases

require "#{ CAP3_ROOT }/helpers/local_copy_patch"

# App Params
set :domain, Configs.domain
set :user,   Configs.role.app.ssh.user

# Dirs
set :bin_dir,     "#{ shared_path }/bin"
set :pids_dir,    "#{ shared_path }/tmp/pids"
set :sockets_dir, "#{ shared_path }/tmp/sockets"
set :configs_dir, "#{ shared_path }/config"
set :log_dir,     "#{ shared_path }/log"

set :web_server_dir, "#{ shared_path }/web_server"

if whenever?
  set :whenever_ns, Configs.whenever.namespace
end

if redis?
  set :redis_port, Configs.redis.port
  set :redis_ns,   Configs.redis.namespace

  set :redis_dir,  "#{ shared_path }/redis_db"
  redis_file_name = "redis_#{ fetch :redis_port }_#{ fetch :redis_ns }"
  set :redis_db_file, redis_file_name

  set :redis_config_file, "#{ redis_file_name }.config"
  set :redis_pid_file,    "redis.pid"
  set :redis_log_file,    "redis.log"
  set :redis_port_file,   "redis.port"

  set :redis_config_file_path, "#{ fetch :configs_dir }/#{ fetch :redis_config_file }"
  set :redis_port_file_path,   "#{ fetch :configs_dir }/#{ fetch :redis_port_file   }"

  set :redis_log_file_path, "#{ fetch :log_dir  }/#{ fetch :redis_log_file }"
  set :redis_pid_file_path, "#{ fetch :pids_dir }/#{ fetch :redis_pid_file }"
end

if sphinx?
  set :sphinx_conf_file, "#{ fetch :configs_dir }/searchd.config"
end

# WebServer params
set :web_server_socket,  Configs.unicorn.socket_name
set :web_server_workers, Configs.unicorn.workers
set :web_server_user,    fetch(:user)

set :web_server_config,  "#{ fetch :web_server_dir }/unicorn/config.rb"
set :web_server_sock,    "#{ fetch :sockets_dir }/unicorn.sock"
set :web_server_pid,     "#{ fetch :pids_dir }/unicorn.pid"

set :web_server_log,     "#{ fetch :log_dir }/unicorn.log"
set :web_server_err,     "#{ fetch :log_dir }/unicorn.err"

# set :default_env,  { path: "/opt/ruby/bin:$PATH" }

# ADDOND for linked files
linked_files_addons  = []

linked_files_addons |= %w[ config/newrelic.yml ]                   if new_relic?
linked_files_addons |= %w[ config/initializers/sidekiq.rb ]        if sidekiq?
linked_files_addons |= %w[ config/schedule.rb config/schedule.rb ] if whenever?

if sphinx?
  linked_files_addons |= %w[ config/thinking_sphinx.yml ]

  # uncomment directive only after ts:first_start
  # linked_files_addons |= %w[ config/searchd.config ]
end

if redis?
  linked_files_addons |= %w[ config/redis.port config/initializers/redis.rb ]
end

set :linked_files, %w[ config/database.yml ] | linked_files_addons
set :linked_dirs,  %w[ bin log search_index tmp vendor/bundle public/system public/uploads ]

# Before/After filters
#########################################################
before "deploy:check:linked_files", "configs:copy"

# Hooks
before "rvm:check", "ask_me:ask_me" if RVM_HOOK

after  "deploy:finished", "deploy:restart"
after  "deploy:finished", "ts:restart"      if sphinx?
after  "deploy:finished", "whenever:update" if whenever?
after  "deploy:finished", "sidekiq:restart" if sidekiq?

# RAILS MIGRATIONS
set :migration_role, :app

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      task! "unicorn:restart" if unicorn?
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'
end