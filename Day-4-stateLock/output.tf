output "public-id" {
  value = aws_instance.name.public_ip
}

output "private-id" {
  value = aws_instance.name.private_ip
}

output "instance-Name" {
  value = aws_instance.name.tags
}

