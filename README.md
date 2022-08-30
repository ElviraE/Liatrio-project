##  EKS CLUSTER FOR DOCKERISED FLASK API WITH TERRAFORM (IAC)

## Prerequisites

- Kubectl — communication tool we will use to communicate between our Kubernetes cluster and our machine. Installation instructions available on https://kubernetes.io/docs/tasks/tools/install-kubectl/
- AWS CLI /2.7.24 — AWS tool which we will use to issue commands related to AWS configurations. To install follow https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
- Docker version 20.10.17 - an open platform for developing, shipping, and running applications. Installation instructions available on https://docs.docker.com/get-docker/



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

Update Kubectl with EKS CONFIG Details

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




## setup aws ecr

Authenticate docker with ecr
Replace region and aws_account_id with your details
'''bash
aws ecr get-login-password --region $(terraform -chdir=eks output -raw region) | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.us-east-1.amazonaws.com
'''


Add tag to the image
```bash
$ docker tag timestampapi $(terraform -chdir=eks output -raw ecr_registry_url)
```
Pushing Docker image

Push Image
```bash
$ docker push  $(terraform -chdir=eks output -raw ecr_registry_url):latest
```

## Kubernetes Manifest

Describe Image_Uri

   Image_Uri=$(terraform -chdir=eks output -raw ecr_registry_url)

Replace the image in deployment/api-deployment.yaml

Kubernetes Deployment

Pod
```bash
$ cat deployment/api-deployment.yaml | sed "s|{{Image_Uri}}|$Image_Uri|" | kubectl apply -f -
```

Service
```bash
$ kubectl apply -f deployment/service.yaml
```

Print out our Service/LoadBalancer

```bash
$ kubectl get svc
```

EXTERNAL_IP of a Load Balancer is our Point of Access



## Cleanup

Delete our Services
```bash
$ kubectl delete svc timestampapi-k8s-service
```
```bash
$ kubectl delete svc kubernetes
```

Make sure you are located in the directory that has Terraform files

```bash
$ terraform destroy
```


## Helpful links

Issue with Adding ECR in AWS with Terraform (Elastic Container Registry): https://www.sysopsruntime.com/2021/07/10/create-elastic-container-registry-ecr-in-aws-with-terraform/

Issue with Multiple security groups tagging: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1986

Issue with sed command to replace the image in kubernetes yaml file: https://stackoverflow.com/questions/60333077/sed-command-to-replace-the-image-in-kubernetes-yaml-file





