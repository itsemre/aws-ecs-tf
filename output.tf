output "redis_arn" {
  description = "ARN of the created Redis cluster."
  value       = aws_elasticache_replication_group.this.arn
}

output "configuration_endpoint" {
  description = "Address of the replication group configuration endpoint."
  value       = aws_elasticache_replication_group.this.configuration_endpoint_address
}

output "redis_cmd" {
  description = "Command for connecting to the created Redis cluster."
  value       = "redis-cli -h ${aws_elasticache_replication_group.this.configuration_endpoint_address} -p ${var.port}"
}

output "ssh_host" {
  description = "Public IP address assigned to the instance."
  value       = aws_instance.this.public_ip
}

output "ssh_cmd" {
  description = "Command for connecting to the SSH host."
  value       = "ssh ubuntu@${aws_instance.this.public_ip}"
}
