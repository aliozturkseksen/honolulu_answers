#!/bin/bash -e

gem install trollop
gem install aws-sdk-core --pre

echo "making $stack_name the new production Jenkins..."

ruby infrastructure/bin/route53switch.rb  --subdomain pipelinedemo --hostedzone $domain --region $region --stackname $stack_name