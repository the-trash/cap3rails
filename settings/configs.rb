ARG_FIRST = ARGV.first
RVM_HOOK  = ENV['RVM_HOOK'] ? (ENV['RVM_HOOK'].downcase == 'true') : true

class Configs < Settingslogic
  src = ARG_FIRST ? "./settings/#{ARG_FIRST}.yml" : "./settings/production.yml.example"

  source src
  namespace "configs"
  reload!
end
