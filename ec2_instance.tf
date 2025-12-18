# Find Amazon Linux 2 Amazon Machine Image (AMI)
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["137112412989"] # Amazon's official AWS account ID
}

# Bastion Host EC2 Instance in the Public Subnet
resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.bastion_server_instance_type
  subnet_id                   = aws_subnet.public.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}_Bastion_Host"
  }
}
# Web Server EC2 Instance in the Public Subnet
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.web_server_instance_type
  subnet_id                   = aws_subnet.public.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
            sudo yum install -y httpd
            sudo systemctl start httpd
            sudo systemctl enable httpd
            echo "<h1>Welcome to the Cloud_Daemon Web Server</h1>" > /var/www/html/index.html
            EOF

  tags = {
    Name = "${var.project_name}_Web_Server"
  }
}

# App Server EC2 Instance in the Private Subnet (no public IP)
resource "aws_instance" "app" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.app_server_instance_type
  subnet_id                   = aws_subnet.private_1.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo yum install -y mariadb-server
            sudo systemctl start httpd
            sudo systemctl enable httpd
            echo "<h1>Welcome to the Cloud_Daemon App Server</h1>" > /var/www/html/index.html
            EOF

  tags = {
    Name = "${var.project_name}_App_Server"
  }
}

