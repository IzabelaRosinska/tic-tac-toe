output "vpc_id" {
    description = "vpc id"
    value = aws_vpc.vpc_tic_tac_toe.id
}

output "subnet_id" {
    description = "private ip(subnet)"
    value = aws_subnet.subnet_tic_tac_toe.id
}

output "IGW_id" {
    description = "internet gateway id"
    value = aws_internet_gateway.igw_tic_tac_toe.id
}

output "routetable_id" {
    description = "route table id"
    value = aws_route_table.rt_tic_tac_toe.id
}

output "SG_id" {
    description = "security group id"
    value = aws_security_group.sg_tic_tac_toe.id
}

output "eip" {
    description = "public Ip of eip"
    value = aws_eip.eip_tic_tac_toe.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2_tic_tac_toe.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2_tic_tac_toe.public_ip
}
