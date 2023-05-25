variable "tg_name" {
  description = "Name of the target group"
  type        = string
}

variable "key_name" {
  description = "Name of the key-pair"
  type        = string
}

variable "public_key" {
  description = "File location of your public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "launch_name" {
  description = "Name of the launch template"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ami_id" {
  description = "Id of the AMI"
  type        = string
  default     = "ami-0eb260c4d5475b901"
}

variable "instance_type" {
  description = "Type of EC2 instance to create"
  type        = string
}

variable "sg_id" {
  description = "ID of the security group"
  type        = string
}

variable "lb_name" {
  description = "Name of the Load Balancer"
  type        = string
}

variable "public_subnet_ids" {
  description = "Map of the public subnet ids."
  type        = map(any)
}

variable "asg_name" {
  description = "Name of the Auto-Scaling Group"
  type        = string
}

variable "min_size" {
  description = "Minimum size of the auto-scaling group"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the auto-scaling group"
  type        = number
}

variable "desired_capacity" {
  description = "Desired size of the auto-scaling group"
  type        = number
}

# Tags
variable "user" {
  description = "User based on workspace"
  type        = string
}
