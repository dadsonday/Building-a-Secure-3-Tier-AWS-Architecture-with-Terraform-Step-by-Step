output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  value       = [aws_subnet.public.id]
}

output "private_subnet_ids" {
  description = "List of Private Subnet IDs"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id, aws_subnet.private_3.id]
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = aws_instance.bastion_host.public_ip
}

output "web_public_ip" {
  description = "Public IP of the Web Server"
  value       = aws_instance.web.public_ip
}

output "app_private_ip" {
  description = "Private IP of the App Server"
  value       = aws_instance.app.private_ip
}

output "rds_endpoint" {
  description = "Endpoint of the RDS Database"
  value       = aws_db_instance.mariadb.endpoint
}