#!/bin/bash


terraform init
terraform apply --auto-approve

HOST_NAME=$(terraform output -raw load_balancer_hostname)

# check for required args
if [ -z $HOST_NAME ]; then
    echo "Deployment failed. Check error in terminal"
    exit 1
fi


URL=http://${HOST_NAME}
PING_URL=${URL}/ping
NEW_URL=${URL}/newurl
GET_URL=${URL}/someurl12

echo You can now use this hostname for the url shortener
echo http://${HOST_NAME}
echo URLs available:
echo 1. ${PING_URL} -get request-
echo 2. ${NEW_URL} -post request-
echo 3. ${GET_URL} -get request-

echo @@@@@@NOTE: DO NOT FORGET TO TERRAFORM DESTROY

# start interact
/bin/bash

