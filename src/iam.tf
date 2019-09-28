################################################################################
################# EKS Master
################################################################################
resource "aws_iam_role" "master" {
  name = "${var.cluster_name}-master"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = "${var.tags}"
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.master.name}"
}

resource "aws_iam_role_policy_attachment" "service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.master.name}"
}

################################################################################
################# EC2 Nodes
################################################################################
resource "aws_iam_role" "node" {
  name = "${var.cluster_name}-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = "${var.tags}"
}

resource "aws_iam_instance_profile" "node" {
  name       = "${var.cluster_name}-node"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.node.name}"
}

# Docs: https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/controller/config/
resource "aws_iam_role_policy" "aws_alb_ingress_controller" {
  name       = "alb_ingress_controller"
  policy     = "${file("${path.module}/iam_policies/aws_alb_ingress_controller.json")}"
  role       = "${aws_iam_role.node.id}"
}

# Docs: https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md
resource "aws_iam_role_policy" "autoscaler" {
  name       = "autoscaler"
  policy     = "${file("${path.module}/iam_policies/autoscaler.json")}"
  role       = "${aws_iam_role.node.id}"
}

# Docs: https://github.com/kubernetes-incubator/external-dns
resource "aws_iam_role_policy" "external_dns" {
  name       = "external_dns"
  policy     = "${file("${path.module}/iam_policies/external_dns.json")}"
  role       = "${aws_iam_role.node.id}"
}
