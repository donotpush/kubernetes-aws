
# Generates kubernetes config that will be applied after terraform apply
data "template_file" "aws_auth" {
  template = "${file("${path.module}/kubectl_templates/aws-auth.yml")}"

  vars = {
    role_arn_node = "${aws_iam_role.node.arn}"
  }
}
resource "local_file" "aws_auth" {
  content  = "${data.template_file.aws_auth.rendered}"
  filename = "config/aws_auth.yml"
}

data "template_file" "autoscaler" {
  template = "${file("${path.module}/kubectl_templates/autoscaler.yml")}"

  vars = {
    cluster_name = "${var.cluster_name}"
    region       = "${data.aws_region.current.name}"
  }
}

resource "local_file" "autoscaler" {
  content  = "${data.template_file.autoscaler.rendered}"
  filename = "config/autoscaler.yml"
}

data "template_file" "external_dns" {
  template = "${file("${path.module}/kubectl_templates/external-dns.yml")}"
  vars = {
    route53_zone_name = "${var.route53_zone_name}"
  }
}

resource "local_file" "external_dns" {
  content  = "${data.template_file.external_dns.rendered}"
  filename = "config/external-dns.yml"
}

data "template_file" "aws_alb_controller_ingress" {
  template = "${file("${path.module}/kubectl_templates/aws-alb-ingress-controller.yml")}"

  vars = {
    cluster_name = "${var.cluster_name}"
  }
}

resource "local_file" "aws_alb_controller_ingress" {
  content  = "${data.template_file.aws_alb_controller_ingress.rendered}"
  filename = "config/aws-alb-ingress-controller.yml"
}
