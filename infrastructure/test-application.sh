#!/bin/bash -e
gem install cucumber net-ssh opendelivery

export SHA=`ruby -e 'require "opendelivery"' -e "puts OpenDelivery::Domain.new('$region').get_property 'honolulu-jenkins-jonny-test','$pipeline_instance_id', 'SHA'"`
echo checking out revision $SHA
git checkout $SHA

export stack_name=`ruby -e 'require "opendelivery"' -e "puts OpenDelivery::Domain.new('$region').get_property 'honolulu-jenkins-jonny-test','$pipeline_instance_id', 'stack_name'"`

cd infrastructure
cucumber