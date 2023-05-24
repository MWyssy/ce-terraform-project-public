output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private-subnets" {
  value = var.private_subs
}

output "public-subnets" {
  value = var.public_subs
}

locals {
  pub_name = values({ for k, v in aws_subnet.subnets : k => v.tags["Name"] if v.availability_zone == "eu-west-2a" && v.map_public_ip_on_launch == true })[0]
}

output "pub-sub" {
  value = aws_subnet.subnets[local.pub_name].id
}
