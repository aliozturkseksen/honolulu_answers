#!/bin/bash -e

export stack_name="Honolulu-Jenkins-`date +%Y%m%d%H%M%S`"

wget https://raw.githubusercontent.com/stelligent/honolulu_jenkins_cookbooks/master/jenkins.template

aws cloudformation create-stack --stack-name $stack_name --template-body "`cat jenkins.template`" --region ${region}  --disable-rollback --capabilities="CAPABILITY_IAM" --parameters ParameterKey=domain,ParameterValue="${domain}" ParameterKey=adminEmailAddress,ParameterValue="jonny@stelligent.com"

ruby infrastructure/bin/monitor_stack.rb  --stack $stack_name --region ${region}



echo "$stack_name created."