################################################################################
################# EKS master
################################################################################
resource "aws_eks_cluster" "this" {
  name     = "${var.cluster_name}"
  role_arn = "${aws_iam_role.master.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.master.id}"]
    subnet_ids         = "${concat(var.private_subnets,var.public_subnets)}"
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    "aws_iam_role_policy_attachment.cluster_policy",
    "aws_iam_role_policy_attachment.service_policy",
    "aws_security_group.master",
  ]
}
