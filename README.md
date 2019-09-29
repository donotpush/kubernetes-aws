
![img](https://miro.medium.com/max/763/1*lgt6E6bGC384R8MKGM3FXw.png )

Fully automated EKS cluster creation including essential configuration to deploying your workloads!

* [kubernetes/autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler)

* [Prometheus + grafana](https://github.com/helm/charts/tree/master/stable/prometheus-operator)

* [kubernetes-incubator/external-dns](https://github.com/kubernetes-incubator/external-dns)

* [kubernetes-sigs/aws-alb-ingress-controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller)
 
* [kubernetes-sigs/aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator)

* [kubernetes/dashboard](https://github.com/kubernetes/dashboard)


AWS EBS, AWS ALB , and AWS Route53 integration also added!


## Pricing

AWS/EKS is `not free` like Google/GKE or Azure/AKS. You pay $0.20 per hour ($140 aprox per month) for the Kubernetes Control Plane, and usual EC2, EBS, and Load Balancing prices for resources that run in your account.

# Installation 

### Requirements:

* [Helm](https://helm.sh/docs/using_helm/#installing-helm)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
* [Terraform 0.12.X](https://terraform.io/downloads.html) (also in `brew`)
* AWS VPC with private and public subnets! 

> Having issues installing the requirements? You can also run everything on `Docker` (check the last section)

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

### Docker installation

Base image is python:3.7-buster (Debian 10) including all the dependencies to run the above commands on CI or local machine.

Local machine installation requires:

* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

```
docker build -t launcher .

docker run -it -p 8001:8001 -w /root -v $(pwd):/root -v $HOME/.kube:/root/.kube -v $HOME/.aws:/root/.aws launcher bash

Step 2 > commands
```
