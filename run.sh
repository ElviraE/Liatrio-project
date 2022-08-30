#!/usr/bin/env sh

[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_fail=0
region="$("$1")"

echo 'Provisioning EKS Cluster'
        terraform -chdir=eks init
        terraform -chdir=eks apply --auto-approve


echo 'Update Kubectl with EKS CONFIG Details'
    aws eks  update-kubeconfig --name $(terraform -chdir=eks output -raw cluster_name) --region $(terraform -chdir=eks output -raw region)

echo 'Build Docker Image'
    docker build -t timestampapi app


echo 'Publish Docker Image'
    aws ecr get-login-password --region $(terraform -chdir=eks output -raw region) | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.us-east-1.amazonaws.com
    docker tag timestampapi $(terraform -chdir=eks output -raw ecr_registry_url)
    docker push $(terraform -chdir=eks output -raw ecr_registry_url):latest


echo 'Describe Image_Uri'
    Image_Uri=$(terraform -chdir=eks output -raw ecr_registry_url)


echo 'Deploy with Kubernetes'
    cat deployment/api-deployment.yaml | sed "s|{{Image_Uri}}|$Image_Uri|" | kubectl apply -f -

        kubectl apply -f deployment/service.yaml

echo 'Print out our Service/LoadBalancer'
    kubectl get svc

echo "EXTERNAL_IP of a Load Balancer is our Point of Access"

