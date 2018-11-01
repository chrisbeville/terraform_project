resource "aws_vpc" "kubernetes-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
      "Name", "terraform-eks",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}
