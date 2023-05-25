output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "sg_id" {
  value = aws_security_group.sg-main.id
}

output "public_subnet_ids" {
  value = {
    for k, subnet in aws_subnet.subnets :
    k => subnet.id
  if subnet.map_public_ip_on_launch == true }
}
