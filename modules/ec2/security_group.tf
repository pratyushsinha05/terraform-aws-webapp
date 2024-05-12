resource "aws_security_group" "aws_sg" {
  name   = "${var.PROJECT_NAME}-sg"
  vpc_id = var.VPC_ID
  tags = {
    PROJECT_NAME = var.PROJECT_NAME
  }
}
resource "aws_security_group_rule" "ssh_rule" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_sg.id
}
resource "aws_security_group_rule" "http_rule" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_sg.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_sg.id
}