CAP3_ROOT = File.expand_path("../", __FILE__)

# RM deprecation warning
I18n.config.enforce_available_locales = true
SSHKit::Backend::Netssh.pool.idle_timeout = 60

# Configuration
require 'settingslogic'
require "#{ CAP3_ROOT }/settings/configs"

# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Ruby/Rails addons
require 'capistrano/bundler'
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets' unless Configs['skip_assets_precompile']

require 'capistrano/rvm' if RVM_HOOK

# Common imports
Dir.glob('helpers/*.rb').each { |r| import r }
Dir.glob('tasks/*.cap').each  { |r| import r }

# Rakes for tools
%w[ unicorn nginx whenever thinking_sphinx redis sidekiq software new_relic ].each do |tool|
  Dir.glob("tasks/#{ tool }/*.cap").each do |tasks_set|
    import tasks_set
  end
end
