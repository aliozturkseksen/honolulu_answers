#!/bin/bash -ev

export stack_name="Honolulu-Jenkins-`date +%Y%m%d%H%M%S`"

gem install trollop
gem install aws-sdk-core --pre

wget https://raw.githubusercontent.com/stelligent/honolulu_jenkins_cookbooks/master/jenkins.template

# Create Honolulu Jenkins stack in VPC
aws cloudformation create-stack --stack-name $stack_name --template-body "`cat jenkins.template`" --region ${region}  --disable-rollback --capabilities="CAPABILITY_IAM" --parameters \
--parameters ParameterKey=domain,ParameterValue="${domain}" \
  ParameterKey=adminEmailAddress,ParameterValue="jonny@stelligent.com" \
  ParameterKey=vpc,ParameterValue=$vpc \
  ParameterKey=publicSubnet,ParameterValue=$publicSubnet \
  ParameterKey=privateSubnetA,ParameterValue=$privateSubnetA \
  ParameterKey=privateSubnetB,ParameterValue=$privateSubnetB \
--output text


ruby infrastructure/bin/monitor_stack.rb  --stack $stack_name --region ${region}

echo "$stack_name created."
