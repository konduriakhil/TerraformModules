locals {
  is_public  = length(var.public_subnets) > 0 ? 1 : 0
  anywhere   = "0.0.0.0/0"
  is_private = length(var.private_subnets) > 0 ? 1 : 0
}