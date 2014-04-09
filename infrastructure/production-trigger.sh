#!/bin/bash -e


# look up last successful pipeline instance
gem install aws-sdk-core --pre

export query="select * from \`honolulu-jenkins-jonny-test\` where furthest_pipeline_stage_completed = \'acceptance\' and started_at is not null order by started_at desc limit 1"

export pipeline_instance_id=`ruby -e 'require "aws-sdk-core"' -e "puts Aws::SDB.new(region: '$region').select(select_expression: '$query').items.first.name"`

export SHA=`ruby -e 'require "opendelivery"' -e "puts OpenDelivery::Domain.new('$region').get_property '$sdb_domain','$pipeline_instance_id', 'SHA'"`

# push instance id into file so we can load it into the environment
echo pipeline_instance_id=$pipeline_instance_id > environment.txt