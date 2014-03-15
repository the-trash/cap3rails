#!/bin/bash
RAILS_ROOT=<%= dest %>
RVM_DO="<%= rvm_do %>"

cd $RAILS_ROOT

echo "try to stop Redis"
(redis-cli -h localhost -p <%= fetch(:redis_port) %> shutdown) || (echo "Redis can't be stop")

echo "try to stop Sidekiq"
($RVM_DO bundle exec sidekiqctl stop ./tmp/pids/sidekiq.pid) || (echo "Sidekiq can't be stop")

echo "try to stop Sphinx"
(RAILS_ENV=<%= fetch :stage %> $RVM_DO bundle exec rake ts:stop) || (echo "Sphinx can't be stop")