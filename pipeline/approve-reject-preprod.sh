#!/bin/bash -e

ruby .pipeline/bin/emails/gate_check_email.rb \
--region $region \
--pipelineid $pipeline_instance_id \
--recipient tech@stelligent.com \
--sender tech@stelligent.com \
--jenkinsurl jenkins.$domain \
--application "Honolulu"

ruby .pipeline/bin/gate_check.rb \
--region $region \
--sdbdomain $sdb_domain \
--pipelineid $pipeline_instance_id \
--check "preprod_check"
