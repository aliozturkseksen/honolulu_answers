## Honolulu Answers AWS Scripting Proof of Concept

Hi there. We used this repo to demonstrate how to script the Honolulu Answers app to deploy in [Amazon Web Services](https://aws.amazon.com/) (AWS). This fork is not intended to be merged back into the original, and we don't plan on keeping it updated with any changes to made to the original. You will incur AWS charges while resources are in use. Use this application at your own risk!

## Setting up the Honolulu Answers application
#### Prereqs:
* [AWS Access Keys](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html) ready and enabled.
* [AWS CLI tool](https://aws.amazon.com/cli/) installed and configured. The quickest way to do this is by launching an Amazon Linux EC2 instance (as the AWS CLI is preinstalled), but you can [install it on your laptop as well](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html), and then configure the application by using the command:


    ```aws configure```

Once your AWS CLI tools are set up, clone this repo and this command will build a Honolulu Answers application infrastructure and then deploy the app to it.

    sudo yum -y install git
    git clone https://github.com/stelligent/honolulu_answers.git
    cd honolulu_answers/
    aws cloudformation create-stack --stack-name HonoluluAnswers --template-body "`cat infrastructure/config/honolulu.template`" --region us-west-2  --disable-rollback --capabilities="CAPABILITY_IAM"

(*NOTE: Alternatively, you can use Jenkins to run through the above steps. However, you'll need to install Jenkins first. To do this, see [https://github.com/stelligent/honolulu_answers_cookbooks](https://github.com/stelligent/honolulu_answers_cookbooks))*. After about 50 minutes, an Opsworks stack is created and launched. To get details:

1. Log into the [OpsWorks](http://console.aws.amazon.com/opsworks) console
3. You should see an OpsWorks stack listed named **Honolulu Answers** -- click on it. If you see more than one listed (because you kicked it off a few times), they are listed in alphabetical-then-chronological order. So the last *Honolulu Answers* stack listed will be the most recent one.
4. Click on **Instances** within the OpsWorks stack you selected.
5. Once the Instance turns green and shows its status as *Online*,you can click the IP address link and the Honolulu Answers application will load!

### Deleting provisioned AWS resources
* Go to the [CloudFormation](http://console.aws.amazon.com/cloudformation) console and delete the corresponding CloudFormation stack. 

### Changes made to this Github Fork

We made several changes to this repository, you can view them here: [Stelligent Changes to the Honolulu Answers Application](https://github.com/stelligent/honolulu_answers/wiki/Stelligent-Changes-to-the-Honolulu-Answers-Application)

### Tools Used

We're using a bunch of great tools for automating and running this application. You can view the list here: [Tools Used](https://github.com/stelligent/honolulu_answers/wiki/Tools-Used)

## Resources 
### Working Systems

* [pipelinedemo.stelligent.com](http://pipelinedemo.stelligent.com/) - Working Continous Integration Server. To setup your own Jenkins server based on the same open source scripts, go to [honolulu_jenkins_cookbooks](https://github.com/stelligent/honolulu_jenkins_cookbooks).
* [appdemo.stelligent.com](http://appdemo.stelligent.com/) - Working Honolulu Answers application based on the automation described in this README. 

### Diagrams
We've put together several diagrams to help show how everything ties together. You can view them here: [Architecture and Design](https://github.com/stelligent/honolulu_answers/wiki/Architecture-and-Design)


