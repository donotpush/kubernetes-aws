# kubernetes-aws

Fully automated EKS cluster creation including essential configuration to deploying your workloads!

* [kubernetes/autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler)

* [Prometheus + grafana](https://github.com/helm/charts/tree/master/stable/prometheus-operator)

* [kubernetes-incubator/external-dns](https://github.com/kubernetes-incubator/external-dns)

* [kubernetes-sigs/aws-alb-ingress-controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller)
 
* [kubernetes-sigs/aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator)

* [kubernetes/dashboard](https://github.com/kubernetes/dashboard)


AWS EBS integration, AWS ALB integration, and AWS Route53 integration also added!


## Pricing

AWS/EKS is `not free` like Google/GKE or Azure/AKS. You pay $0.20 per hour ($140 aprox per month) for the Kubernetes Control Plane, and usual EC2, EBS, and Load Balancing prices for resources that run in your account.

# Installation 

### Requirements:

* AWS account
* helm
* kubectl
* awscli (python package)
* aws-iam-authenticator
* terraform 0.12.X


### Steps

1. Edit main.tf and provider.tf file with your own AWS infrastructure settings

2. Run the following commands:
```
# Custer creation
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
```

### Docker image for CI

Dockerfile based image python 3.7.X built on Debian 10 (buster) including all the dependencies to run the above commands.
