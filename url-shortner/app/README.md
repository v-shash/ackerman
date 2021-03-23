#### Test locally

#### build docker image locally

```shell
docker build -t mhusseini/bitly .
```

#### create env.list with the following environment variables

```console
AWS_ACCESS_KEY_ID=HelloIAmSecretAccessKeyID
AWS_SECRET_ACCESS_KEY=HelloIAmSecretAccessKey
AWS_DEFAULT_REGION=us-east-1
AWS_REGION=us-east-1
BASE_URL=http://localhost:8080
DB_TABLE_NAME=HelloIAmDBTable
```

**NOTE:** DynamoDB table configured earlier in DB_TABLE_NAME must exist in your account

#### run docker container

```shell
docker run -it --env-file=env.list -p 8080:8080 mhusseini/bitly bash
```

#### run application

```shell
node index.js
```
