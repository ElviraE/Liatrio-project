##  EKS CLUSTER FOR DOCKERISED FLASK API WITH (IAC)

## Requirements

This setup requires awscli docker and kubectl
- aws-cli/2.7.24
- Docker version 20.10.17
- kubectl 



## RUNNING THIS SETUP CAN BE DONE MANUALLY BY RUNNING THE STEPS BELOW OR BY EXECUTING the run.sh script

## 1. Running run.sh
```bash
$ chmod +x run.sh
```

```bash
$ run.sh aws_region 
```

## 2. STEPS
## Deploy EKS Cluster
Initialise terraform 
```bash
$ terraform -chdir=eks init
```

Explore the Plan

```bash
$ terraform -chdir=eks plan
```

Apply Use the default region

```bash
$ terraform -chdir=eks apply --auto-approve
```

OR

Apply with a region specified

```bash
$ terraform -chdir=eks apply  -var="region=${region}" --auto-approve
```

Update kubectl config
aws eks  update-kubeconfig --name $(terraform -chdir=eks output -raw cluster_name) --region $(terraform -chdir=eks output -raw region)



## Build Docker

Build Docker Image Locally

```bash
$ docker build --tag timestampapi app
```

"
Docker Run to test

```bash
$ docker run -d --name timestampapi -p 5000:5000 timestampapi
```
"




## setup aws ecr

Authenticate docker with ecr
Replace region and aws_account_id with your details
'''bash
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.us-east-1.amazonaws.com
'''


Add tag to the image
```bash
$docker image tag timestampapi:latest   $(terraform -chdir=eks output -raw ecr_registry_url)
```
Pushing Docker image

Push Image
```bash
$ docker image push  $(terraform -chdir=eks output -raw ecr_registry_url):latest
```

## Kubernetes Manifest

Replace the image in deployment/api-deployment.yaml

Kubernete Deployment

Pod
```bash
$ cat deployment/api-deployment.yaml | sed "s/{{Image_Uri}}/$(terraform -chdir=eks output -raw ecr_registry_url)/g" | kubectl apply -f -
```

Service
```bash
$ kubectl apply -f deployment/service.yaml
```


## Endpoints
```bash
$ echo $(terraform -chdir=eks output -raw ecr_registry_url)
```