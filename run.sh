#!/usr/bin/env sh

[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_main () {
    _fail=0
    region="$("$1")"

    echo 'Provisoning EKS Cluster'
        try 
            terraform -chdir=eks init
            if [ -z "${region}" ];
            then
                terraform -chdir=eks apply --auto-approve
            else
                terraform -chdir=eks apply  -var="region=${region}" --auto-approve
        catch 
            echo "Raised an Error (@ $__EXCEPTION_LINE__)"

    echo 'Update Kubectl with EKS CONFIG Details'
    try 
        aws eks --region $(terraform -chdir=eks output -raw region) update-kubeconfig --name $(terraform -chdir=eks output -raw cluster_name)
    catch 
        echo "Raised an Error (@ $__EXCEPTION_LINE__)"



    echo 'Update Kubectl with EKS CONFIG Details'
    try 
        aws eks  update-kubeconfig --name $(terraform -chdir=eks output -raw cluster_name) --region $(terraform -chdir=eks output -raw region)
    catch 
        echo "Raised an Error (@ $__EXCEPTION_LINE__)"


    echo 'Build Docker Image'
    try 
        docker build --tag timestampapi app
    catch 
        echo "Raised an Error (@ $__EXCEPTION_LINE__)"

    echo 'Publish Docker Image'
    try 
        aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.us-east-1.amazonaws.com
        docker image tag timestampapi:latest   $(terraform -chdir=eks output -raw ecr_registry_url)
        docker image push  $(terraform -chdir=eks output -raw ecr_registry_url):latest
    catch 
        echo "Raised an Error (@ $__EXCEPTION_LINE__)"

    echo 'Deploy with Kubernetes'
    try 
        cat deployment/api-deployment.yaml | sed "s/{{Image_Uri}}/$(terraform -chdir=eks output -raw ecr_registry_url)/g" | kubectl apply -f -

        kubectl apply -f deployment/service.yaml
    catch 
        echo "Raised an Error (@ $__EXCEPTION_LINE__)"

    
    echo "Endpoint"
    echo $(terraform -chdir=eks output -raw cluster_endpoint)

}

_main "$@"
if [ $_fail -gt 0 ] ; then
    echo "$0: Failed"
    exit 1
fi