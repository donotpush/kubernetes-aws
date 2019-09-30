
![img](https://miro.medium.com/max/763/1*lgt6E6bGC384R8MKGM3FXw.png )

## Introduction 

Fully automated EKS cluster creation including essential configuration to deploying your workloads! It will take you **less than 30 minutes** to complete this guide!

The architecture components are basically:

* Master node (EKS cluster) and Worker nodes (EC2 instances)

* [kubernetes/autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler), integrates Kubernetes with EC2 ASG increasing/decreasing the worker fleet.

* [Prometheus + grafana](https://github.com/helm/charts/tree/master/stable/prometheus-operator), monitoring, dashboard and alerting system.

* [kubernetes/dashboard](https://github.com/kubernetes/dashboard), general purpose, web-based UI for Kubernetes clusters.

* AWS add-ons to integrate services like IAM, Route53, EBS, and ALB(load balancer)
    * [kubernetes-incubator/external-dns](https://github.com/kubernetes-incubator/external-dns)

    * [kubernetes-sigs/aws-alb-ingress-controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller)
 
    * [kubernetes-sigs/aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator)

* REST API deployment example


## Pricing

AWS/EKS is `not free` like Google/GKE or Azure/AKS. You pay $0.20 per hour ($140 aprox per month) for the Kubernetes Control Plane, and usual EC2, EBS, and Load Balancing prices for resources that run in your account.

# Installation guide

There are only three steps to get this done:

1. Install requirements, tools used to deploy the solution! You can also use the docker image (check bellow)!

2. Tag your AWS VPC and subnets

3. Cluster creation/deployment

### Step 1: requirements installation

MacOS commands included, if you are using another OS just click on the links!

* [Helm](https://helm.sh/docs/using_helm/#installing-helm)
```
brew install kubernetes-helm
```
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
```
brew install kubectl 
```
* [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
```
pip install awscli 
```
> Note: Checkout out the **pyenv** project if you have issues with `pip`
* [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
```
brew install aws-iam-authenticator
```
* [Terraform 0.12.X](https://terraform.io/downloads.html) (also in `brew`)
```
brew install terraform
```
* Your own existing AWS infrastructure resources:
    * Route53 hosted zone
    * AWS VPC with public and private subnets 


> Having issues installing the requirements? You can also run everything on `Docker` (check the last section)

### Step 2: VPC tagging considerations

You must choose your `cluster name` at this moment, and replace the CLUSTER_NAME!

- VPC tags:  
    
    | Key        | Value           | 
    | ------------- |:-------------:| 
    | kubernetes.io/cluster/`CLUSTER_NAME`    | shared | 


- Private subnets tags:
    
    | Key        | Value           | 
    | ------------- |:-------------:| 
    | kubernetes.io/cluster/`CLUSTER_NAME`    | shared | 
    | kubernetes.io/role/internal-elb    | 1 | 

- Public subnets tags:
    
    | Key        | Value           | 
    | ------------- |:-------------:| 
    | kubernetes.io/cluster/`CLUSTER_NAME`    | shared | 
    | kubernetes.io/role/elb        | 1 | 



### Step 3: cluster creation/deployment

1. Set your AWS infrastructure config values, there are two options:
```
Option 1: Use this repository, just edit terraform.tfvars with your own settings, and jump to step 2.

Option 2: Use another repository, and treat this repository as a terraform module.  Module example:

    module "cluster" {
        source  = "git@github.com:donotpush/kubernetes-aws.git"
        
        cluster_name = "my-first-cluster"
        vpc_id = "vpc-XXXX"
        private_subnets = ["subnet-XXXX","subnet-XXXX","subnet-XXXX"]
        public_subnets = ["subnet-XXXX","subnet-XXXX","subnet-XXXX"]
        min_size = 1
        max_size = 2
        instance_type = "m4.large"
        route53_zone_name = "example.io"
        region = "eu-west-1"
        tags = {
            Environment = "dev"
            Project = "K"
            Team = "X"
        }
    }
```

2. Run the following commands:
```
# Cluster creation/deployment
terraform init
terraform plan
terraform apply

# Update your kubectl config 

aws eks --region eu-west-1 update-kubeconfig --name my-first-cluster


# Deploy kubectl config files generate by terraform 

ls config/
kubectl apply -f ./config 


# Deploy dashboard and open it!

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}') (copy the token)

kubectl proxy

open http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login

# Deploy prometheus and grafana

helm init --service-account tiller
kubectl create namespace monitoring
helm install --name prometheus stable/prometheus-operator --namespace monitoring

# Prometheus UI

kubectl port-forward -n monitoring  prometheus-prometheus-prometheus-oper-prometheus-0 9090:9090
open http://localhost:9090/graph 

# Grafana UI
kubectl --namespace monitoring port-forward $(kubectl get pods --namespace monitoring -l "app=grafana,release=prometheus" -o jsonpath="{.items[0].metadata.name}") 3000

open http://localhost:3000/login

username: admin
password: kubectl get secret --namespace monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```


### Deploy the application example 

```
1. Modify the `domain name` on echoserver/echoserver.yml line 51

2. Modify the `the ip` on echoserver/echoserver.yml line 48

What's your IP? > curl https://ifconfig.io/

2. Deploy it!

kubectl apply -f ./echoserver

kubectl get pods -n echoserver

kubectl logs <pod-id> -f -n echoserver

3. Test it! You probably should wait a minute!

curl http://echoserver.example.io -I

4. Delete it!

kubectl delete -f ./echoserver
```

### Docker image for CI/CD

Base image is python:3.7-buster (Debian 10) including all the dependencies to run the above commands on your CI/CD.

```
docker build -t launcher .
```

### Cluster IAM considerations

if you are planning on using different IAM roles or users to access the cluster administration via kubectl. You will need to modify your `./config/aws-auth.yml` file!

Check the AWS Docs: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html