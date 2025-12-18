# Bastion Host Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-bastion-sg"
  description = "Security group for Bastion Host"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}

# Web Server SG
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for Web Servers"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

# App Server SG
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app-sg"
  description = "Security group for App Servers"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

# Database Server SG
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Security group for Database Servers"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}

# Bastion inbound: SSH from admin IP
resource "aws_security_group_rule" "bastion_ssh_admin" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.admin_cidr]
  security_group_id = aws_security_group.bastion_sg.id
  description       = "SSh from admin CIDR"
}

# Bastion inbound: HTTP/S from anywhere
resource "aws_security_group_rule" "bastion_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

# Web inbound: SSH from Bastion
resource "aws_security_group_rule" "web_ssh_from_web" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.web_sg.id
  description              = "SSH from Bastion Host"
}

# Web inbound: HTTP/S from anywhere
resource "aws_security_group_rule" "web_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}
resource "aws_security_group_rule" "web_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

#Web inbound: ICMP from app security group
resource "aws_security_group_rule" "web_icmp_from_app" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id        = aws_security_group.web_sg.id
  description              = "ICMP from App Servers"
}

# App inbound: SSH from bastion
resource "aws_security_group_rule" "app_ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.app_sg.id
  description              = "SSH from Bastion Host"
}

# App inbound: All ICMP from web Security group
resource "aws_security_group_rule" "app_icmp_from_web" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id        = aws_security_group.app_sg.id
  description              = "ICMP from Web Servers"

}

# App inbound: App MySQL  from Database securty group
resource "aws_security_group_rule" "app_mysql_from_db" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.db_sg.id
  security_group_id        = aws_security_group.app_sg.id
  description              = "MySQL from Database Servers"
}


# App inbound: HTTP/S from Anywhere
resource "aws_security_group_rule" "app_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}
resource "aws_security_group_rule" "app_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}

# Database inbound: MySQL from App Security Group
resource "aws_security_group_rule" "db_mysql_from_app" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id        = aws_security_group.db_sg.id
  description              = "MySQL from App Servers"
}

# Database inbound: MySQL from Bastion Security Group
resource "aws_security_group_rule" "db_mysql_from_bastion" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.db_sg.id
  description              = "MySQL from Bastion Host"
}

# Allow outbound for all security groups (default is allow, but being explicit)
resource "aws_security_group_rule" "bastion_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}
resource "aws_security_group_rule" "web_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}
resource "aws_security_group_rule" "app_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}
resource "aws_security_group_rule" "db_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db_sg.id
}