set :stage, :production

# RVM
set :rvm_type, :user
set :rvm_ruby_version, [Configs.rvm.ruby, Configs.rvm.gemset].join('@')
# set :rvm_custom_path,  "/var/www/.rvm"

# BUNDLER
# set :bundle_roles,    :all
# set :bundle_binstubs, -> { shared_path.join('bin') }
# set :bundle_path,     -> { shared_path.join('bundle') }
# set :bundle_without,  %w{development test}.join(' ')
set :bundle_flags,      '--deployment' # --quiet

# SSH defaults
# forward_agent
# pub key form local machine available for remote repo
set :ssh_options, {
  forward_agent: true
}

# App Server params
server Configs.role.app.address,
  roles: %w[ web app ],
  ssh_options: Configs.role.app.ssh.to_hash.symbolize_keys

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)