#!/bin/bash
RAILS_ROOT=<%= dest %>
RVM_DO="<%= rvm_do %>"

cd $RAILS_ROOT

echo "try to start Redis"
(redis-server ./config/<%= fetch :redis_config_file %>) || (echo "Redis can't be started")

echo "try to start Sidekiq"
($RVM_DO bundle exec sidekiq -e <%= fetch :stage %> -d -C ./config/sidekiq.yml) || (echo "Sidekiq can't be started")

echo "try to start Sphinx"
(RAILS_ENV=<%= fetch :stage %> $RVM_DO bundle exec rake ts:start)     || (echo "Sphinx can't be started")