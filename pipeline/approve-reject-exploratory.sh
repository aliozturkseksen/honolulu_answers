#!/bin/bash -e

export SHA=`ruby -e 'require "opendelivery"' -e "puts OpenDelivery::Domain.new('$region').get_property '$sdb_domain','$pipeline_instance_id', 'SHA'"`

ruby pipeline/bin/emails/exploratory_check_email.rb \
--region $region \
--pipelineid $pipeline_instance_id \
--recipient paul.duvall@stelligent.com \
--sender paul.duvall@stelligent.com \
--jenkinsurl jenkins.$domain \
--application "Honolulu" \
--gitsha $SHA

ruby pipeline/bin/gate_check.rb \
--region $region \
--sdbdomain $sdb_domain \
--pipelineid $pipeline_instance_id \
--check "exploratory_check"
