

# #cretae a application load balancer
# resource "aws_lb" "jenkins-alb" {
#   name               = "jenkins-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = ["${aws_security_group.alb.id}"]
#   subnets            = ["${aws_subnet.public[0].id}", "${aws_subnet.public[1].id}", "${aws_subnet.public[2].id}"]
#   #subnets = aws_subnet.public.id


#   #enable_deletion_protection = false


#   tags = {
#     Name = "jenkins-alb"

#   }
# }

# #attach 80 listner to alb
# resource "aws_lb_listener" "jenkins-listeners" {
#   load_balancer_arn = aws_lb.jenkins-alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.jenkins-tg.arn
#     redirect {
#       port        = "80"
#       protocol    = "HTTP"
#       status_code = "HTTP_301"
#     }
#   }
# }
# #create a target group 
# resource "aws_lb_target_group" "jenkins-tg" {
#   name     = "jenkins-tg"
#   port     = 8080
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc.id
#   health_check {
#     path     = "/"
#     port     = "8080"
#     interval = "60"
#     enabled  = true
#   }
# }
# #register the target instance to target group
# resource "aws_lb_target_group_attachment" "jenkins-tg-attachment" {
#   target_group_arn = aws_lb_target_group.jenkins-tg.arn
#   target_id        = aws_instance.jenkins.id
#   port             = 8080
# }

# # attach target group with host based rule

# resource "aws_lb_listener_rule" "host_based_routing" {
#   listener_arn = aws_lb_listener.jenkins-listeners.arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.jenkins-tg.arn
#   }
#   condition {
#     host_header {
#       values = ["krishna.maheswargoud.xyz"]
#     }
#   }
# }


resource "aws_lb" "jenkins-alb" {
  name               = "jenkins-alb-lb-tf"
  internal           = false
  load_balancer_type = "application"
  #security_groups    = [aws_security_group.alb.id]
  #subnets            = ["${aws_subnet.dev-public-subnet-1a.id}", "${aws_subnet.dev-public-subnet-1b.id}" , "${aws_subnet.dev-public-subnet-1c.id}"]
  security_groups    = ["${aws_security_group.alb.id}"]
  subnets            = ["${aws_subnet.public[0].id}", "${aws_subnet.public[1].id}", "${aws_subnet.public[2].id}"]
  #enable_deletion_protection = true


  tags = {
    Environment = "jenkins-alb"
  }
}


# instance target group

resource "aws_lb_target_group" "jenkins-tg" {
  name     = "jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   =  aws_vpc.vpc.id
}



resource "aws_lb_target_group_attachment" "jenkins-alb" {
  target_group_arn = aws_lb_target_group.jenkins-tg.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}





# listner


resource "aws_lb_listener" "rnr_end" {
  load_balancer_arn = aws_lb.jenkins-alb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins-tg.arn
  }
}  