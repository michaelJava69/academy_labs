output "zones" {
  description = "Availability Zones in us-west-2"
  value       = data.aws_availability_zones.zones.names
}



