# VPC ID
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.vpc.id
}

# Public Subnet ID
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public-1.id
}

# Private Subnet ID
output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private-1.id
}

# Elastic IP for NAT Gateway
output "nat_gateway_eip" {
  description = "Elastic IP associated with the NAT Gateway"
  value       = aws_eip.eip.public_ip
}

# NAT Gateway ID
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

# Public EC2 Public IP
output "public_ec2_public_ip" {
  description = "Public IP address of the public EC2 instance"
  value       = aws_instance.public-ec2.public_ip
}

# Public EC2 Private IP
output "public_ec2_private_ip" {
  description = "Private IP address of the public EC2 instance"
  value       = aws_instance.public-ec2.private_ip
}

# Private EC2 Private IP
output "private_ec2_private_ip" {
  description = "Private IP address of the private EC2 instance"
  value       = aws_instance.private-ec2.private_ip
}

output "aws_lb-dns-name" {
  value = aws_lb.lb.dns_name
}