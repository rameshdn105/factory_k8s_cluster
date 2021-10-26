# data "aws_ami" "eks_node" {
#   filter {
#     name   = "name"
#     #values = ["amazon-eks-node-${aws_eks_cluster.eks.version}-v*"]
#     #values = ["amazon-eks-*"]
#      #values = ["eks-worker-*"]
#      values = ["amazon-eks-node-*"]
#   }

#   most_recent = true
#   owners      = ["${var.node_ami_owner}"]
# }

locals {
  eks_node_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority.0.data}' '${var.cluster_name}'
USERDATA
}

resource "aws_launch_configuration" "eks" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.eks_node.name}"
  image_id                    = "ami-002595b7394a41704"
  instance_type               = "${var.node_size}"
  name_prefix                 = "eks-${var.cluster_name}"
  security_groups             = "${list(aws_security_group.eks_node_to_node.id)}"
  user_data_base64            = "${base64encode(local.eks_node_userdata)}"
  key_name                    = "BastionKey" # hard-coded for the time being

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks" {
  count                = "${length(var.subnets)}"
  launch_configuration = "${aws_launch_configuration.eks.id}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  name                 = "eks-${var.cluster_name}-${element(aws_subnet.eks_subnet-private.*.availability_zone, count.index)}"
  vpc_zone_identifier  = ["${element(aws_subnet.eks_subnet-private.*.id, count.index)}"]
  termination_policies = ["NewestInstance", "OldestLaunchConfiguration"]

  tag {
    key                 = "Name"
    value               = "eks-${var.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = ""
    propagate_at_launch = true
  }
}