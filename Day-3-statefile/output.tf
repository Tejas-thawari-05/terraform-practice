output "public-ip" {
  value = aws_instance.name.public_ip
}

output "private-ip" {
  value = aws_instance.name.private_ip
}

output "instance-name" {
  value = aws_instance.name.tags
}