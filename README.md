Building a Secure 3-Tier AWS Architecture with Terraform (Step-by-Step)

<img width="720" height="446" alt="image" src="https://github.com/user-attachments/assets/e2eba4af-c1e7-4c48-99e2-5fa422380645" />

Infrastructure as Code (IaC) has become a foundational skill for cloud engineers and Terraform is one of the most powerful tools to implement it. In this post, I’ll walk through how I designed and deployed a secure, production-style 3-tier AWS architecture using Terraform, based on a real-world lab scenario and best practices.

This project demonstrates how networking, security, compute, and database layers come together in AWS — all provisioned automatically with Terraform.

📌 Project Overview

The goal of this project was to implement a 3-tier architecture consisting of:

A public access layer (Bastion + Web)
A private application layer
A private database layer
Deployed across two Availability Zones (us-east-1a and us-east-1b)
All resources are provisioned using Terraform, ensuring repeatability, consistency, and automation.

🧱 Architecture Summary

The architecture includes:

VPC: 192.168.0.0/16
Public Subnet (AZ us-east-1a): 192.168.1.0/24
Private Subnet — App (AZ us-east-1a): 192.168.2.0/24
Private Subnet — DB Primary (AZ us-east-1a): 192.168.3.0/24
Private Subnet — DB Secondary (AZ us-east-1b): 192.168.4.0/24
🧩 Terraform Project Structure

To keep the code clean and maintainable, the project was split into logical Terraform files. This structure allows engineers to quickly locate and manage resources.

1. Project Variables

Configuration variables are separated for easy environment customization.

variables.tf defines the variables and their types.

<img width="720" height="419" alt="image" src="https://github.com/user-attachments/assets/0cf03a84-a5c3-4025-b361-aafe569e6ecb" />

terraform.tfvars holds the specific values for the current deployment.

<img width="720" height="415" alt="image" src="https://github.com/user-attachments/assets/e2e13da4-9316-48c1-a762-c41803e9b3a3" />

2. provider.tf - Defining AWS and Terraform Versions

This file specifies the AWS provider and the required versions.

<img width="720" height="416" alt="image" src="https://github.com/user-attachments/assets/9a2f1515-a6fe-4950-881f-5367ce49b53d" />

3. main.tf - VPC and Main Networking

The core network components are defined, starting with the VPC.

<img width="720" height="436" alt="image" src="https://github.com/user-attachments/assets/af2333df-30c6-45a4-b6cf-2e102d19c688" />

Verification in Console: The VPC is provisioned and available.

<img width="720" height="279" alt="image" src="https://github.com/user-attachments/assets/bbef614f-a70e-4615-8894-3c02f728e976" />

4. subnet_and_routing.tf - Subnets and Route Tables

We create public and private subnets across two AZs for redundancy.

<img width="720" height="421" alt="image" src="https://github.com/user-attachments/assets/f34b8e4c-d4e1-4211-9900-99b1db1ec866" />

Verification in Console: The deployed subnets confirm the networking design. Note the distinct private and public subnets.

<img width="720" height="259" alt="image" src="https://github.com/user-attachments/assets/0c6e294b-94f0-4178-ba87-3f4e565de274" />

5. nat_and_igw.tf - NAT Gateway and Routing

A NAT Gateway is crucial for private instances to initiate outbound connections (e.g., for software updates) without being publicly accessible.


<img width="720" height="412" alt="image" src="https://github.com/user-attachments/assets/b5a48cc3-5ba1-4f68-ab78-7ff42ff5b21c" />

Verification in Console: Elastic IP (EIP) Allocation the EIP is successfully allocated and tagged for the NAT Gateway.

<img width="720" height="278" alt="image" src="https://github.com/user-attachments/assets/48e97240-ff18-44a8-a8e9-668ef9fc30a6" />

Verification in Console: The Route Tables show the explicit separation of routing. The Private RT is associated with three private subnets.

<img width="720" height="294" alt="image" src="https://github.com/user-attachments/assets/3e3a77ff-05cf-492c-8201-316b092c9d10" />

🔐 Security Design (security_groups.tf)
Each tier has its own Security Group (SG), enforced using SG-to-SG rules for least privilege. This prevents unauthorized direct access between tiers.

<img width="720" height="420" alt="image" src="https://github.com/user-attachments/assets/cbecfc18-8b99-4577-8169-7ac7bf62abd4" />

Security Groups Summary

Bastion Host SG: SSH (22) allowed only from admin IP (admin_cidr).
Web Server SG: HTTP (80) / HTTPS (443) from the internet, SSH only from Bastion SG.
App Server SG: SSH from Bastion SG, data traffic only from Web SG.
Database SG: MySQL (3306) only from App and Bastion SGs.
Verification in Console: The creation of the required security groups is confirmed.

<img width="720" height="273" alt="image" src="https://github.com/user-attachments/assets/3d159b00-8fba-43a6-8568-a27652f577e4" />

🖥️ Compute Layer (ec2_instances.tf)

The instances are provisioned across the public and private layers.

<img width="720" height="420" alt="image" src="https://github.com/user-attachments/assets/d409edf2-3af1-4933-b733-e81358e6f316" />

Verification in Console: All three instances (Web, App, and Bastion) are running.

<img width="720" height="279" alt="image" src="https://github.com/user-attachments/assets/a3b4b41e-a9df-4e74-9328-f3ab36b240b5" />

Verification of EBS Volumes: The corresponding EBS volumes for these instances are also confirmed.
<img width="720" height="291" alt="image" src="https://github.com/user-attachments/assets/dc58dc52-ac40-4491-91bf-92535cdf551f" />

🗄️ Database Layer (rds.tf)

The database is an Amazon RDS MariaDB instance, configured as non-publicly accessible (publicly_accessible = false) and placed only in the private subnets.
<img width="720" height="416" alt="image" src="https://github.com/user-attachments/assets/a7ea64b7-d60a-4ef7-8237-3683ca7227f8" />

Verification in Console: The database instance is up and ready.

<img width="720" height="280" alt="image" src="https://github.com/user-attachments/assets/63c5d0d9-276b-44c9-b77c-bebf11e55497" />

🚀 Deployment Workflow

The entire infrastructure is deployed using a single command sequence:

terraform init
terraform plan
terraform apply
Verification: The deployment finishes successfully with 43 resources added.
<img width="720" height="437" alt="image" src="https://github.com/user-attachments/assets/c44e743c-94e5-41ab-82ef-4fb836aecc82" />
Final Outputs (outputs.tf)

The outputs provide critical access information, such as the public IP of the Bastion Host and the private endpoint of the RDS database.

<img width="720" height="420" alt="image" src="https://github.com/user-attachments/assets/57c3d22d-c68e-411d-bb08-890b8d1d4234" />

OutputValueApp Private IP192.168.2.81Bastion Public IP44.223.15.66RDS Endpointtier3-arch-mariadb.cyjrna644l9m.us-east-1.rds.amazonaws.com:3306

✅ Key Takeaways

This project successfully demonstrates the deployment of a professional, secure AWS 3-tier architecture using Terraform, highlighting:

Network Segmentation (Public vs. Private Subnets)
Controlled Outbound Access (NAT Gateway)
Principle of Least Privilege (SG-to-SG rules)
Infrastructure as Code for repeatable environments
🏁 Final Thoughts

By combining clean Terraform code with a well-thought-out architecture, you gain confidence in designing scalable cloud systems. This project serves as an excellent foundation for any cloud engineer.

https://youtu.be/OEkb-hu0QcE


Subscribe to my channel and hit the bell icon, I’ll be sharing a full tutorial video on the above soon.

Happy Learning!



