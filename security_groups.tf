resource "aws_security_group" "webdmz" {
  name        = "WebDMZ"
  description = "WebDMZ"
  vpc_id = module.vpc.vpc_id

  # https
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = true
  }
  
  # http
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self= true
  }

  # SSH from bastion
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion.id]
    self= true
  }

  # all
  egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "${var.vpc_name}-webdmz-sg"
  }
}


resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "bastion sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.home_ip_cidr]
    self = true
    description = "Bastion from home IP"
  }

  # all
  egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "${var.vpc_name}-bastion-sg"
  }
}



resource "aws_security_group" "db" {
  name        = "db-sg"
  description = "database sg"
  vpc_id = module.vpc.vpc_id

  # MySQL
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.webdmz.id, aws_security_group.bastion.id]
    self = true
    description = "MySQL from WebDMZ and Bastion"
  }

  # http from bastion
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.bastion.id]
    description = "http from Bastion"
  }

  # https from bastion
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [aws_security_group.bastion.id]
    description = "https from Bastion"
  }

  # all
  egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "${var.vpc_name}-db-sg"
  }
}