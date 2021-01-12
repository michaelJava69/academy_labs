output "server1_ip" {
  description = "Server 1 public IP"
  value       = aws_instance.server1.public_ip
}

output "server2_ip" {
  description = "Server 2 public IP"
  value       = aws_instance.server2.public_ip
}

