#!/bin/bash -e

# generate pipeline instance id
export pipeline_instance_id=`date +%Y%m%d%H%M%S`-$BUILD_NUMBER
echo pipeline_instance_id=$pipeline_instance_id

# lookup the SHA of the latest commit
GIT_SHA=`git log | head -1 | awk '{ print $2 }'`

# save instance id to SDB
gem install opendelivery
ruby -e 'require "opendelivery"' -e "OpenDelivery::Domain.new('$region').set_property 'honolulu-jenkins-jonny-test','$pipeline_instance_id', 'SHA', '$GIT_SHA'"

# push instance id into file so we can load it into the environment
echo pipeline_instance_id=$pipeline_instance_id > environment.txt