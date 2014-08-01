#!/bin/bash -e

ruby .pipeline/bin/emails/gate_check_email.rb \
--region "us-east-1" \
--pipelineid $pipeline_instance_id \
--recipient paul.duvall@stelligent.co \
--sender paul.duvall@stelligent.co \
--jenkinsurl samplepipeline.$domain \
--application "Honolulu"

ruby .pipeline/bin/gate_check.rb \
--region $region \
--sdbdomain $sdb_domain \
--pipelineid $pipeline_instance_id \
--check "preprod_check"
