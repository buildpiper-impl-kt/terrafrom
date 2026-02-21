####################  Node Groups Variable  ####################
# Define the shape of each node group. All tiers (app, db, middleware, etc.)
# are driven from this single variable — add a key, get a full node group.

variable "node_groups" {
  description = "Map of EKS node group configurations. Add a new key to create a new node group."
  type = map(object({
    # Networking
    subnet_ids           = list(string)
    associate_public_ip  = bool
    security_groups      = list(string)

    # Compute
    instance_type = string
    capacity_type = string   # ON_DEMAND or SPOT

    # Scaling
    desired_size = number
    max_size     = number
    min_size     = number

    # Storage
    ebs_volume_size       = number
    ebs_volume_type       = string
    delete_on_termination = bool
    encrypted             = bool

    # Taints
    taint_key    = string
    taint_value  = string
    taint_effect = string   # NO_SCHEDULE | PREFER_NO_SCHEDULE | NO_EXECUTE
  }))
}
