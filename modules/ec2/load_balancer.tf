resource "aws_alb" "load_balancer" {
  name               = "${var.PROJECT_NAME}-elb"
  load_balancer_type = "application"
  internal           = false
  ip_address_type    = "ipv4"
  subnets            = var.PUBLIC_SUBNET_IDS

  security_groups    = [
    aws_security_group.aws_sg.id,
  ]
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.PROJECT_NAME}-tg"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = var.VPC_ID
  health_check {
    healthy_threshold   = 5
    interval            = 30
    timeout             = 5
    protocol            = "HTTP"
    unhealthy_threshold = 2
    path                = "/"
  }
  tags = {
    PROJECT_NAME = var.PROJECT_NAME
  }
}

resource "aws_autoscaling_attachment" "web-app" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.target_group.arn
}