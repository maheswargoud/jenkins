resource "aws_instance" "jenkins" {
  ami           = "ami-0f36dcfcc94112ea1"
  instance_type = "t2.micro"
  #   vpc_id = aws_vpc.vpc.id  
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  key_name               = aws_key_pair.ownkey.id
  #user_data       = file("jenkins-install.sh")
  user_data = data.template_file.user_data.rendered

  tags = {
    Name = "Prod-jenkins"
  }
}


data "template_file" "user_data" {
  template = "${file("jenkins-install.sh")}"
}