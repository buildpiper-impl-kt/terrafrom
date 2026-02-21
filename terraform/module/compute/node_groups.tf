###################### Dynamic EKS Node Groups ####################
# To add a new node group (e.g. middleware), just add an entry to
# the `node_groups` variable in your tfvars — no new blocks needed.

###################### Locals ####################

locals {
  # Shared prefix used across all node group and launch template names
  cluster_prefix  = "${var.env}-${var.project_name}-eks"
  node_group_name = "${local.cluster_prefix}-node-group"

  # Dynamically generate per-tier names from the node_groups map keys.
  # e.g. for key "app"        → lt_name    = "dev-myproject-eks-app-lt"
  #                            → group_name = "dev-myproject-eks-node-group-app"
  # Adding "middleware" key   → names are generated automatically, no edits here needed.
  node_groups_config = {
    for key, ng in var.node_groups : key => merge(ng, {
      lt_name    = "${local.cluster_prefix}-${key}-lt"
      group_name = "${local.node_group_name}-${key}"
    })
  }
}

####################  Launch Templates  ####################

resource "aws_launch_template" "eks_node_launch_template" {
  for_each = local.node_groups_config

  name_prefix   = each.value.lt_name
  key_name      = var.key_pair != "" ? var.key_pair : null
  instance_type = each.value.instance_type

  network_interfaces {
    associate_public_ip_address = each.value.associate_public_ip
    security_groups             = each.value.security_groups
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name  = each.value.group_name
      env   = var.env
      owner = var.owner
    }
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = each.value.ebs_volume_size
      volume_type           = each.value.ebs_volume_type
      delete_on_termination = each.value.delete_on_termination
      encrypted             = each.value.encrypted
    }
  }

  tags = {
    Name  = each.value.group_name
    env   = var.env
    owner = var.owner
  }

  depends_on = [aws_security_group.sg]
}

####################  Node Groups  ####################

resource "aws_eks_node_group" "node_group" {
  for_each = local.node_groups_config

  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = each.value.group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = each.value.subnet_ids

  ami_type      = var.ami_type
  capacity_type = each.value.capacity_type

  launch_template {
    id      = aws_launch_template.eks_node_launch_template[each.key].id
    version = "$Latest"
  }

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  labels = {
    "Name" = each.value.group_name
  }

  taint {
    key    = each.value.taint_key
    value  = each.value.taint_value
    effect = each.value.taint_effect
  }

  tags = {
    Name  = each.value.group_name
    env   = var.env
    owner = var.owner
  }
}
