resource "aws_eks_cluster" "kubernetes-cluster" {
  name = "${var.cluster-name}"
  role_arn = "${aws_iam_role.kubernetes-cluster-role.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.kubernetes-cluster.id}"]
    subnet_ids = ["${aws_subnet.subnetwork1.id}", "${aws_subnet.subnetwork2.id}"]
  }
}
