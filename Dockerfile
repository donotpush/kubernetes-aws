FROM python:3.7-buster

ENV TERRAFORM_VERSION=0.12.7

RUN apt-get update && \
    apt-get install -y apt-transport-https make gnupg2 build-essential && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl && \
    curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && mv aws-iam-authenticator /bin/ && \
    curl -L https://git.io/get_helm.sh | bash

RUN curl -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip *.zip && rm -f *.zip  && mv -v terraform /bin/ 

RUN pip install awscli