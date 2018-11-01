data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_ami" "eks_worker" {
  filter {
    name = "name"
    values = ["amazon-eks-node-v*"]
  }

  most_recent = true
  owners = ["602401143452"] #Amazon EKS AMI Account ID
}
