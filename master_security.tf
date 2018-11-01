resource "aws_security_group" "kubernetes-cluster" {
  name = "terraform-eks-kubernetes-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id = "${aws_vpc.kubernetes-vpc.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "terraform-eks"
  }
}
