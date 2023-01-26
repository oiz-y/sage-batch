# sage-batch:dolphin:

## Overview:eyes:

This project is a batch computation of Galois groups of integer coefficient irreducible polynomials generated at random.

## Usage:white_check_mark:

### Build and Push docker image

We use [AWS Batch](https://aws.amazon.com/batch/) as batch compute system and [SageMath](https://hub.docker.com/r/sagemath/sagemath) for Docker images.

#### 1. Build image

```
$ git clone https://github.com/oiz-y/sage-batch.git
$ cd sage-batch
$ docker build -t sage-batch .
```

#### 2. Push image

```
$ aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
$ docker tag sage-batch:latest ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/sage-batch:latest
$ docker push ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/sage-batch:latest
```

### Create Batch Environment

#### 1. Prepare

- get account id

```
AWS_ACCOUNT_ID=`aws sts get-caller-identity | jq -r .Account`
```

- get region

```
AWS_REGION=`curl -s http://169.254.169.254/task/TaskARN | cut -d ":"  -f 4`
```

#### 2. Create Computing Environment

```
aws batch create-compute-environment \
--compute-environment-name sage-batch-computing-env \
--type MANAGED --state ENABLED \
--service-role arn:aws:iam::${AWS_ACCOUNT_ID}:role/aws-service-role/batch.amazonaws.com/AWSServiceRoleForBatch \
--compute-resources type=FARGATE,maxvCpus=256,\
subnets=subnet-xxxxxxxx,subnet-yyyyyyyyy,subnet-zzzzzzzz,securityGroupIds=sg-wwwwwwww
```

#### 3. Create Job Queue

```
aws batch create-job-queue \
--job-queue-name sage-batch-job-queue \
--priority 1 \
--state ENABLED \
--compute-environment-order order=1,computeEnvironment=sage-batch-computing-env
```

#### 4. Register Job Definition

```
aws batch register-job-definition \
--job-definition-name sage-batch-job-def \
--type container \
--platform-capabilities FARGATE \
--container-properties image=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/sage-batch:latest,\
executionRoleArn=arn:aws:iam::${AWS_ACCOUNT_ID}:role/ecsTaskExecutionRole,\
jobRoleArn=arn:aws:iam::${AWS_ACCOUNT_ID}:role/ecsJobRole,\
environment="[{name=S3_BUCKET,value=sage-batch-bucket},{name=COEFFICIENT_RANGE,value=1000000000},{name=PRIME_RANGE,value=500},{name=EXCEPT_GROUP,value=NotSelected},{name=DEGREE,value=2},{name=MAX_TIMES,value=100}]",\
resourceRequirements="[{type=VCPU,value=1.0},{type=MEMORY,value=2048}]",\
command=sh,run.sh,\
logConfiguration={logDriver=awslogs},\
networkConfiguration={assignPublicIp=ENABLED},\
fargatePlatformConfiguration={platformVersion=LATEST}
```

|env variable|default|description|
|-|-|-|
|S3_BUCKET|sage-batch-bucket|S3 bucket to output the calculation results|
|COEFFICIENT_RANGE|1000000000|Coefficient range|
|PRIME_RANGE|500|Prime range|
|EXCEPT_GROUP|NotSelected|Groups to exclude notifications|
|DEGREE|2|Degree of polynomial to generate|
|MAX_TIMES|1|Number of polynomials to generate|

#### 5. Submit Job

```
aws batch submit-job \
--job-name sage-batch-job \
--job-queue sage-batch-job-queue \
--job-definition sage-batch-job-def
```

## Related links

### https://galoisapp.com/

This application computes the Galois group of the input integer coefficients.

Project link : https://github.com/oiz-y/sage-lambda-container-app

## Reference:book:

- https://www.sagemath.org/
- https://github.com/sagemath/sage

## License:bell:

- [MIT](https://github.com/oiz-y/sage-batch/blob/main/LICENSE)
