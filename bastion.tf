
resource "aws_instance" "bastion" {
  ami           = "ami-0f36dcfcc94112ea1"
  instance_type = "t2.micro"
  #   vpc_id = aws_vpc.vpc.id  
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = aws_key_pair.ownkey.id

  tags = {
    Name = "Prod-bastion"
  }
}