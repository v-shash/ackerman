#!/bin/bash

# help section
usage()
{
cat << EOF
usage: bash ./awssh -n name -k private_key
-n    | --name              (Required)            instance name to ssh to
-k    | --private_key       (Required)            private key to use in ssh
-h    | --help                                    Brings up this menu
EOF
}


if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    usage;
    exit 1
fi

# parse arguments
while [ "$1" != "" ]; do
    case $1 in
        -n | --name )
            shift
            name=$1
        ;;
        -k | --private_key )
            shift
            private_key=$1
        ;;
        -h | --help )    usage
            exit
        ;;
        * )              usage
            exit 1
    esac
    shift
done

# check for required args
if [ -z $private_key ]; then
    echo "private key is required to ssh, provide it with the flag: -k private_key"
    exit 1
fi

if [ -z $name ]; then
    echo "Instance name is required, provide it with the flag: -n name"
    exit 1
fi


# parse output of aws cli
OUTPUT=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=${name}" \
    --query "Reservations[*].Instances[*].PublicIpAddress" \
  --output=text)


STRING_LIST=(${OUTPUT[@]})


if [ -z "${OUTPUT}" ] # check if no instance matches
then
      echo "Host not found"
      exit 1
elif [ "${#STRING_LIST[@]}" -gt 1 ] # check if two or more instances matching
then
      echo "Two or more instances match the instance name. Script supports only one"
      echo "IP address of instances: "
      echo "${OUTPUT}"
      exit 1
fi

# ssh
ssh ec2-user@${OUTPUT} -i ${private_key}