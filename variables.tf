# Terraform Variables for AWS Deployment
# Author: Dominic Kwasi Appiah
# Date: 2024-06-10

# AWS Region
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-1"
}

# AWS Project Name
variable "project_name" {
  description = "Projecct name used for resource naming"
  type        = string
  default     = "tire3-arch"
}

# Key Pair Name for EC2 Instances
variable "key_name" {
  description = "Name of the existing key pair to use for EC2 instances"
  type        = string
}

# Admin CIDR for SSH Access
variable "admin_cidr" {
  description = "CIDR block for admin ssh access"
  type        = string
  default     = "0.0.0.o/0"
}

# VPC Cidr
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

# Public Subnet 1 Cidr
variable "public_subnet_1_cidr" {
  description = " Public subnet1 CIDR block"
  type        = string
  default     = "192.168.1.0/24"
}
# Private Subnet 1 Cidr
variable "private_subnet_1_cidr" {
  type        = string
  description = "Private subnet1 CIDR block"
  default     = "192.168.2.0/24" # App server
}



# Private Subnet 2 Cidr
variable "private_subnet_2_cidr" {
  type        = string
  description = "Private subnet2 CIDR block"
  default     = "192.168.3.0/24" # Database Primary
}

# Private Subnet 3 Cidr
variable "private_subnet_3_cidr" {
  type        = string
  description = "Private subnet3 CIDR block"
  default     = "192.168.4.0/24" # Database Secondary
}

# EC2 Instance Type for Application Server
variable "app_server_instance_type" {
  description = "EC2 instance type for the application server"
  type        = string
  default     = "t2.micro"
}

#EC2 Instance Type for Bastion Server
variable "bastion_server_instance_type" {
  type    = string
  default = "t2.micro"
}

#EC2 Instance Type for Web Server
variable "web_server_instance_type" {
  type    = string
  default = "t2.micro"
}
# RDS Username
variable "rds_username" {
  description = "Username for the RDS database"
  type        = string
  default     = "root"
}

# RDS Password
variable "rds_password" {
  description = "Password for the RDS database"
  type        = string
  default     = "Re:Start!9"
  sensitive   = true
}

#RDS Allocated Storage
variable "rds_allocated_storage" {
  description = "Allocated storage for the RDS database"
  type        = number
  default     = 20
}
 
 # Get two AZs in the specified region
variable "availability_zones" {
  description = "List of availability zones in the specified region"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
} 
