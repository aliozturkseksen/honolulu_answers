#!/bin/bash -e

export SHA=`ruby -e 'require "opendelivery"' -e "puts OpenDelivery::Domain.new('$region').get_property '$sdb_domain','$pipeline_instance_id', 'SHA'"`

ruby pipeline/bin/emails/preprod_check_email.rb \
--region "us-east-1" \
--pipelineid $pipeline_instance_id \
--recipient jonny@stelligent.com \
--sender jonny@stelligent.com \
--jenkinsurl samplepipeline.$domain \
--application "Honolulu"
--gitsha $SHA

ruby pipeline/bin/gate_check.rb \
--region $region \
--sdbdomain $sdb_domain \
--pipelineid $pipeline_instance_id \
--check "preprod_check"
