# VPC Vars
variable "vpc_name" {
  description = "Name of the main VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR range of the VPC"
  type        = string
}

# Internet Gateway Vars
variable "ig_name" {
  description = "Name of the internet gateway"
  type        = string
}

# Subnet Vars
variable "subnets" {
  description = "Map of the subnets to create."
  type        = map(any)
}

# Nat-Gateway Vars
variable "private_subs" {
  description = "Map of the private subnets created"
  type        = map(any)
}

variable "public_subs" {
  description = "Map of the private subnets created"
  type        = map(any)
}

variable "pub_name" {
  type        = string
  description = "Find name of public subnet in the same az"
}

# Tags
variable "user" {
  description = "User based on workspace"
  type        = string
}
