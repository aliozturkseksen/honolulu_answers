#!/bin/bash -e
gem install opendelivery

export SHA=`ruby -e 'require "opendelivery"' -e "puts OpenDelivery::Domain.new('us-west-2').get_property 'honolulu-jenkins-jonny-test','$pipeline_instance_id', 'SHA'"`
echo checking out revision $SHA
git checkout $SHA

export stack_name=`ruby -e 'require "opendelivery"' -e "puts OpenDelivery::Domain.new('us-west-2').get_property 'honolulu-jenkins-jonny-test','$pipeline_instance_id', 'stack_name'"`

aws cloudformation delete-stack --stack-name $stack_name --region $region