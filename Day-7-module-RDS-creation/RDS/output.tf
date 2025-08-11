output "rds_endpoint" {
  value = aws_db_instance.RDS.endpoint
}

output "rds_id" {
  value = aws_db_instance.RDS.id
}
