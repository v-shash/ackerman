# URL shortener service deployment

- [URL shortener service](#url-shortener-service)
  - [Prerequisites](#prerequisites)
    - [1. Docker](#1-docker)
    - [2. cd into deployment directory](#2-cd-into-deployment-directory)
    - [3. AWS User with Admin privileges](#3-aws-user-with-admin-privileges)
    - [4. Build docker container used to deploy infrastructure](#4-build-docker-container-used-to-deploy-infrastructure)
  - [Deploy](#deploy)
  - [License](#license)

## Prerequisites

#### 1. Docker

Please make sure to have docker installed.

#### 2. AWS User with Admin privileges

replace env.list.example with env.list and update the following variables

```
AWS_ACCESS_KEY_ID=HelloIAmSecretAccessKeyID
AWS_SECRET_ACCESS_KEY=HelloIAmSecretAccessKey
```

#### 3. Build docker container used to deploy infrastructure

```shell
docker build -t mhusseini/deploy_url_shortener .
```

## Deploy

To deploy (linux), please run

```bash
docker run --env-file=env.list -it -v $(pwd):/usr/src/deploy -w /usr/src/deploy mhusseini/deploy_url_shortener
```

You should get an output like

```console
You can now use this hostname for the url shortener
http://blablabla.us-east-1.elb.amazonaws.com
URLs available:
1. http://blablabla.us-east-1.elb.amazonaws.com/ping -get request-
2. http://blablabla.us-east-1.elb.amazonaws.com/newurl -post request-
3. http://blablabla.us-east-1.elb.amazonaws.com/someurl12 -get request-
@@@@@@NOTE: DO NOT FORGET TO TERRAFORM DESTROY
```

## Destroy

To destroy infrastruture while you're still inside the container

```shell
terraform destroy
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
