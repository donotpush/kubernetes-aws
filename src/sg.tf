################################################################################
################# EKS master
################################################################################
resource "aws_security_group" "master" {
  name        = "${var.cluster_name}-master"
  description = "EKS master ${var.cluster_name}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      "Name" = "${var.cluster_name}-master"
    },
  )
}

resource "aws_security_group_rule" "ingress_node" {
  type                     = "ingress"
  description              = "Allow node ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.master.id
  source_security_group_id = aws_security_group.node.id
}

################################################################################
################# EC2 Nodes
################################################################################

resource "aws_security_group" "node" {
  name        = "${var.cluster_name}-node"
  description = "EKS node ${var.cluster_name}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      "Name"                                      = "${var.cluster_name}-node"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
  )
}

resource "aws_security_group_rule" "ingress_self" {
  type                     = "ingress"
  description              = "Allow node self traffic any protocol"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.node.id
  depends_on               = [aws_security_group.node]
}

resource "aws_security_group_rule" "ingress_master" {
  type                     = "ingress"
  description              = "Allow master ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.master.id
  depends_on = [
    aws_security_group.node,
    aws_security_group.master,
  ]
}

