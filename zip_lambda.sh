#!/bin/bash

set -e

# replace the value with your S3 bucket name
S3_BUCKET_NAME="denis-gaina-cloudformation"
CF_STACK_NAME="denis-gaina-stack"
AWS_PROFILE_NAME="default"

# archiving code
zip code.zip ./code.py

# updating s3 with updated code
# comment out the below line if your aws profile in the credentials file is not named this way
export AWS_PROFILE=$AWS_PROFILE_NAME
aws s3 sync . s3://$S3_BUCKET_NAME/lambda --region=us-east-1

# validating template
CF_VALIDATION=$(aws cloudformation validate-template --template-url https://$S3_BUCKET_NAME.s3.us-east-1.amazonaws.com/lambda/lambda.yaml --region=us-east-1)
echo $CF_VALIDATION

# extracting capabilities from validation
CAPABILITIES=$(echo $CF_VALIDATION | jq -r '.Capabilities[]')

# creating stack
DATEANDTIME=$(date '+%Y-%m-%d-%H-%M-%S')
aws cloudformation create-stack --stack-name $CF_STACK_NAME-$DATEANDTIME --template-url https://$S3_BUCKET_NAME.s3.us-east-1.amazonaws.com/lambda/lambda.yaml --capabilities $CAPABILITIES --region=us-east-1

# deleting stack
# aws cloudformation delete-stack --stack-name $CF_STACK_NAME-$DATEANDTIME --region=us-east-1
