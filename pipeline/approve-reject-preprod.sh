#!/bin/bash -e

ruby pipeline/bin/emails/preprod_check_email.rb \
--region "us-east-1" \
--pipelineid $pipeline_instance_id \
--recipient jonny@stelligent.co \
--sender jonny@stelligent.co \
--jenkinsurl samplepipeline.$domain \
--application "Honolulu"

ruby pipeline/bin/gate_check.rb \
--region $region \
--sdbdomain $sdb_domain \
--pipelineid $pipeline_instance_id \
--check "preprod_check"
