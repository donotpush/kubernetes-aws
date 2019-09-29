# Generates kubernetes config that will be applied after terraform apply
data "template_file" "aws_auth" {
  template = file("${path.module}/templates/aws-auth.yml")

  vars = {
    role_arn_node = aws_iam_role.node.arn
  }
}

resource "local_file" "aws_auth" {
  content  = data.template_file.aws_auth.rendered
  filename = "config/aws_auth.yml"
}

data "template_file" "autoscaler" {
  template = file("${path.module}/templates/autoscaler.yml")

  vars = {
    cluster_name = var.cluster_name
    region       = var.region
  }
}

resource "local_file" "autoscaler" {
  content  = data.template_file.autoscaler.rendered
  filename = "config/autoscaler.yml"
}

data "template_file" "external_dns" {
  template = file("${path.module}/templates/external-dns.yml")
  vars = {
    route53_zone_name = var.route53_zone_name
  }
}

resource "local_file" "external_dns" {
  content  = data.template_file.external_dns.rendered
  filename = "config/external-dns.yml"
}

data "template_file" "aws_alb_controller_ingress" {
  template = file("${path.module}/templates/aws-alb-ingress-controller.yml")
  vars = {
    cluster_name = var.cluster_name
  }
}

resource "local_file" "aws_alb_controller_ingress" {
  content  = data.template_file.aws_alb_controller_ingress.rendered
  filename = "config/aws-alb-ingress-controller.yml"
}


resource "local_file" "aws_alb_ingress_controller_rbac" {
  content  = file("${path.module}/templates/aws-alb-ingress-controller-rbac.yml")
  filename = "config/aws-alb-ingress-controller-rbac.yml"
}

resource "local_file" "eks_admin_service_account" {
  content  = file("${path.module}/templates/eks-admin-service-account.yml")
  filename = "config/eks-admin-service-account.yml"
}

resource "local_file" "ebs" {
  content  = file("${path.module}/templates/ebs.yml")
  filename = "config/ebs.yml"
}

resource "local_file" "tiller" {
  content  = file("${path.module}/templates/tiller.yml")
  filename = "config/tiller.yml"
}
