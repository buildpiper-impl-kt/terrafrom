####################  terraform.tfvars  ####################
# This is the ONLY file you need to touch to add/remove node groups.
# Copy an existing block and change the key name + values.

node_groups = {

  # ── App tier ──────────────────────────────────────────────
  app = {
    subnet_ids           = ["subnet-aaa111", "subnet-aaa222"]
    associate_public_ip  = false
    security_groups      = ["sg-app123"]

    instance_type = "t3.medium"
    capacity_type = "ON_DEMAND"

    desired_size = 2
    max_size     = 5
    min_size     = 1

    ebs_volume_size       = 50
    ebs_volume_type       = "gp3"
    delete_on_termination = true
    encrypted             = true

    taint_key    = "tier"
    taint_value  = "app"
    taint_effect = "NO_SCHEDULE"
  }

  # ── DB tier ────────────────────────────────────────────────
  db = {
    subnet_ids           = ["subnet-bbb111", "subnet-bbb222"]
    associate_public_ip  = false
    security_groups      = ["sg-db456"]

    instance_type = "r5.large"
    capacity_type = "ON_DEMAND"

    desired_size = 2
    max_size     = 4
    min_size     = 1

    ebs_volume_size       = 100
    ebs_volume_type       = "gp3"
    delete_on_termination = false
    encrypted             = true

    taint_key    = "tier"
    taint_value  = "db"
    taint_effect = "NO_SCHEDULE"
  }

  # ── Middleware tier (new — just add this block, nothing else!) ──
  middleware = {
    subnet_ids           = ["subnet-ccc111", "subnet-ccc222"]
    associate_public_ip  = false
    security_groups      = ["sg-mw789"]

    instance_type = "t3.large"
    capacity_type = "ON_DEMAND"

    desired_size = 2
    max_size     = 6
    min_size     = 1

    ebs_volume_size       = 50
    ebs_volume_type       = "gp3"
    delete_on_termination = true
    encrypted             = true

    taint_key    = "tier"
    taint_value  = "middleware"
    taint_effect = "NO_SCHEDULE"
  }

}
