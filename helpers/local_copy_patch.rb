# to create local configs for Application
if ARGV[1] == 'local:copy'
  module Capistrano
    module DSL
      module Paths
        def current_path; deploy_path; end
        def shared_path;  deploy_path; end
      end
    end
  end
end