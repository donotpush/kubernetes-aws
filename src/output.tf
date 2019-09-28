output "cluster_arn" {
  value = "${aws_eks_cluster.this.arn}"
}
output "role_arn_master" {
  value = "${aws_iam_role.master.arn}"
}
output "role_arn_node" {
  value = "${aws_iam_role.node.arn}"
}
output "sg_id_node" {
  value = "${aws_security_group.node.id}"
}
output "sg_id_master" {
  value = "${aws_security_group.master.id}"
}

