require 'ostruct'

def rvm_do
  rvm_path = fetch(:rvm_path)
  rvm_path = rvm_path.nil? ? fetch(:rvm_custom_path) : "#{ rvm_path }/bin/rvm"
  "#{ rvm_path } #{ fetch(:rvm_ruby_version) } do"
end

def task! name
  Rake::Task[name].invoke
end

def template(from, to, params = {})
  debug     = params[:debug]
  namespace = OpenStruct.new(params)
  erb       = File.read CAP3_ROOT + "/templates/#{ from }"
  res       = ERB.new(erb).result(namespace.instance_eval { binding })
  puts "", ("! "*25), res, ("! "*25), "" if debug
  upload! StringIO.new(res), to
end

def local_template(from, to, params = {})
  debug     = params[:debug]
  namespace = OpenStruct.new(params)
  t_path    = "/templates/#{ from }"
  erb       = File.read CAP3_ROOT + t_path
  res       = ERB.new(erb).result(namespace.instance_eval { binding })
  puts "", ("! "*25), res, ("! "*25), "" if debug

  puts "#{ t_path } => #{ to }"
  content = StringIO.new(res).read
  File.open(to, 'w+'){ |file| file.write content }
end

# REMOTE FILE SYSTEM TEST
def remote_file_exists? path
  return true if test "[ -f #{ path } ]"
  error "FILE NOT FOUND #{ path }"
  false
end

def remote_dir_exists? path
  return true if test "[ -d #{ path } ]"
  error "DIR NOT FOUND #{ path }"
  false
end

def remote_symlink_exists? path
  return true if test "[ -L #{ path } ]"
  error "SYMLINK NOT FOUND #{ path }"
  false
end

# Check for tool
def new_relic?
  Configs.tools.new_relic
end

def whenever?
  Configs.tools.whenever
end

def sphinx?
  Configs.tools.sphinx
end

def unicorn?
  Configs.web_server == "unicorn"
end

def sidekiq?
  Configs.tools.sidekiq
end

def redis?
  Configs.tools.redis
end