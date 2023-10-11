#!/bin/bash

set -e

# archiving code
zip code.zip ./code.py

# updating s3 with updated code
# comment out the below line if your aws profile in the credentials file is not named this way
export AWS_PROFILE=default
aws s3 sync . s3://denis-gaina-cloudformation/lambda

# validating template
CF_VALIDATION=$(aws cloudformation validate-template --template-url https://denis-gaina-cloudformation.s3.us-east-1.amazonaws.com/lambda/lambda.yaml)
echo $CF_VALIDATION

# extracting capabilities from validation
CAPABILITIES=$(echo $CF_VALIDATION | jq -r '.Capabilities[]')

# creating stack
DATEANDTIME=$(date '+%Y-%m-%d-%H-%M-%S')
aws cloudformation create-stack --stack-name denis-gaina-stack-$DATEANDTIME --template-url https://denis-gaina-cloudformation.s3.us-east-1.amazonaws.com/lambda/lambda.yaml --capabilities $CAPABILITIES --region=us-east-1
