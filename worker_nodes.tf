locals {
  userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.this.endpoint}' --b64-cluster-ca '${aws_eks_cluster.this.certificate_authority[0].data}' '${var.cluster_name}'
USERDATA

}

data "aws_ami" "node" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.this.version}-v*"]
  }
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

resource "aws_launch_configuration" "node" {
  name_prefix          = "${var.cluster_name}-node"
  instance_type        = var.instance_type
  image_id             = data.aws_ami.node.id
  user_data_base64     = base64encode(local.userdata)
  security_groups      = [aws_security_group.node.id]
  iam_instance_profile = aws_iam_instance_profile.node.name

  depends_on = [
    aws_security_group.master,
    aws_eks_cluster.this,
    aws_security_group.node,
    aws_iam_instance_profile.node,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "node" {
  launch_configuration = aws_launch_configuration.node.id
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${var.cluster_name}-node"
  vpc_zone_identifier  = var.private_subnets

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-node"
    propagate_at_launch = true
  }

  depends_on = [
    aws_security_group.master,
    aws_eks_cluster.this,
    aws_launch_configuration.node,
  ]

  # Tags docs: https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/aws
  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "yes"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
    value               = "yes"
    propagate_at_launch = true
  }

  # AWS ASG metrics 
  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

