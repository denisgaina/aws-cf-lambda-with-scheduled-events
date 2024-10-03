## What you're gonna need for this:
1. Install AWS CLI version 2
2. Create an access key in the aws console and add it locally as [described here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#awsui-tabs-0-9610-long-term-credentials)
3. Suggestion: install `jq`, and you can test jq stuff on [jmespath.org](https://jmespath.org/)

## Actually doing stuff:
1. assign a default region in which we will operate

    `export AWS_DEFAULT_REGION=us-east-1`

2. create a bucket with 
   
   `aws s3api create-bucket --bucket denis-gaina-cloudformation --region=us-east-1`

3. you can list all buckets with the command
   
   `aws s3 ls`

4. deploy the cloudformation stack by running the shell script, you can create your own shell script

    `chmod +x zip_lambda.sh`
    
    `sh zip_lambda.sh`

5. you can list all cloudformation stacks with 
   
   `aws cloudformation list-stacks`

6. Since aws cli returns lots of json, we can use jq to filter the results

    `aws cloudformation list-stacks | jq '[.StackSummaries[] | {(.StackName) : .StackStatus}]'`

    or 

    `aws cloudformation list-stacks | jq '.StackSummaries[] | select(.StackName=="denis-gaina-stack")'`

7. In order to check the events of a specific stack we can use 
    
    `aws cloudformation describe-stack-events --stack-name denis-gaina-stack`

8. you can delete the stack with
    
    `aws cloudformation delete-stack --stack-name denis-gaina-stack`
