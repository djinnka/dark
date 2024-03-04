output "public_ip_standby" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.primary_1.public_ip
}

output "public_ip_replica" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.replica_1.public_ip
}