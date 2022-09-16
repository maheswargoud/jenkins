data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}


#alb-sg
resource "aws_security_group" "alb" {
  name        = "allow_End users"
  description = "Allow End users inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "End users from Admin"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = var.alb-sg,
    Terraform = "true"
  }
}


#bastion-sg
resource "aws_security_group" "bastion" {
  name        = "bastion-demo"
  description = "Allow admin with ssh"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Connecting admin on ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = var.bastion-sg,
    terraform = "true"
  }
}


#jenkins-sg
resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "Allow to jenkins"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Connecting enduser"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    # cidr_blocks = [aws_security_group.bastion.id]
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description = "Connecting from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = ["103.110.170.82/32"]
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = "jenkins-sg",
    terraform = "true"
  }
}