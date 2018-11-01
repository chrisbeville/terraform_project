resource "aws_subnet" "subnetwork1" {
  availability_zone = "us-east-1a"
  cidr_block = "10.0.1.0/24"
  vpc_id = "${aws_vpc.kubernetes-vpc.id}"

  tags = "${
    map(
      "Name", "terraform-eks-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "subnetwork2" {
  availability_zone = "us-east-1b"
  cidr_block = "10.0.2.0/24"
  vpc_id = "${aws_vpc.kubernetes-vpc.id}"

  tags = "${
    map(
      "Name", "terraform-eks-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "kubernetes-gateway" {
  vpc_id = "${aws_vpc.kubernetes-vpc.id}"

  tags {
    Name = "terraform-eks"
  }
}

resource "aws_route_table" "kubernetes-route-table" {
  vpc_id = "${aws_vpc.kubernetes-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.kubernetes-gateway.id}"
  }
}

resource "aws_route_table_association" "kubernetes-route-table-association-1" {
  subnet_id = "${aws_subnet.subnetwork1.id}"
  route_table_id = "${aws_route_table.kubernetes-route-table.id}"
}

resource "aws_route_table_association" "kubernetes-route-table-association-2" {
  count = 2

  subnet_id = "${aws_subnet.subnetwork2.id}"
  route_table_id = "${aws_route_table.kubernetes-route-table.id}"
}
