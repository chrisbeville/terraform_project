resource "aws_autoscaling_group" "kubernetes" {
  desired_capacity = 3
  launch_configuration = "${aws_launch_configuration.kubernetes.id}"
  max_size = 5
  min_size = 2
  name = "terraform-eks-kubernetes"
  vpc_zone_identifier = ["${aws_subnet.subnetwork1.id}", "${aws_subnet.subnetwork2.id}"]

  tag {
    key = "Name"
    value = "terraform-eks-kubernetes"
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.cluster-name}"
    value = "owned"
    propagate_at_launch = true
  }
}

locals {
  kubernetes-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.kubernetes-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.kubernetes-cluster.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA
}

resource "aws_launch_configuration" "kubernetes" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.node.name}"
  image_id                    = "${data.aws_ami.eks_worker.id}"
  instance_type               = "m4.large"
  name_prefix                 = "terraform-eks-demo"
  security_groups             = ["${aws_security_group.kubernetes-node.id}"]
  user_data_base64            = "${base64encode(local.kubernetes-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}
