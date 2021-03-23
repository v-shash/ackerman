# awssh

Utility script to get an AWS instance IP address and ssh into that instance.

## Prerequisites

#### AWS CLI

AWS CLI should be installed. You can find instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

#### Configure

AWS CLI should be configured by running

    aws configure

#### SSH Key Pair

A public key should be configured in the aws environment (account) where the the instance is. Also you should have the matching private key with the correct permissions. You can find a tutorial [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

## Usage

```
./awssh -n name -k private_key
-n    | --name              (Required)            instance name to ssh to
-k    | --private_key       (Required)            private key to use in ssh
-h    | --help                                    Brings up this menu
```

## Example

```console
./awssh -n api-server-002 -k ./keys/default_key.pem
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
