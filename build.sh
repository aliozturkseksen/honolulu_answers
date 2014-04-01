#!/bin/bash -e

export SHA=`ruby -e 'require "opendelivery"' -e "puts OpenDelivery::Domain.new('us-west-2').get_property 'honolulu-jenkins-jonny-test','$pipeline_instance_id', 'SHA'"`
echo checking out revision $SHA
git checkout $SHA

export RAILS_ENV="test"
export BHT_API_KEY="7868d47a7c43908cc80a44738acebb41"

gem install bundler

bundle install
bundle exec rake db:drop
bundle exec rake db:setup
bundle exec rake spec

# Run static analysis
gem install brakeman --version 2.1.1
brakeman -o brakeman-output.tabs
