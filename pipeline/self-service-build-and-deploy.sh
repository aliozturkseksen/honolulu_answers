#!/bin/bash -e

echo checking out revision $SHA
git checkout $SHA

timestamp=`date +%Y%m%d%H%M%S`

gem install trollop opendelivery --no-ri --no-rdoc
gem install aws-sdk-core --pre --no-ri --no-rdoc
export stack_name=HonoluluAnswers-$timestamp
aws cloudformation create-stack --stack-name $stack_name --template-body "`cat infrastructure/config/honolulu.template`" --region ${region}  --disable-rollback --capabilities="CAPABILITY_IAM"
# make sure we give AWS a chance to actually create the stack...
sleep 30
ruby infrastructure/bin/monitor_stack.rb  --stack $stack_name --region ${region}

