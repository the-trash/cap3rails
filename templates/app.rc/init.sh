#!/bin/bash
RAILS_ROOT=<%= dest %>
RVM_DO="<%= rvm_do %>"

cd $RAILS_ROOT

echo "try to initialize Sphinx"
(RAILS_ENV=<%= fetch :stage %> $RVM_DO bundle exec rake ts:configure) || (echo "Sphinx can't be configated")
(RAILS_ENV=<%= fetch :stage %> $RVM_DO bundle exec rake ts:index)     || (echo "Sphinx can't be indexed")