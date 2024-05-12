resource "aws_launch_template" "launch_template" {
  image_id = var.EC2_IMAGE_ID
  key_name               = var.KEY_PAIR_NAME
  instance_type = var.EC2_INSTANCE_TYPE
  iam_instance_profile {
    name = "EC2InstanceRole"
  }
  user_data = filebase64("${path.module}/userdata.sh")
  network_interfaces {
    associate_public_ip_address = true
    security_groups = ["${aws_security_group.aws_sg.id}"]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name         = "${var.PROJECT_NAME}-server"
      PROJECT_NAME = var.PROJECT_NAME
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = "${var.PROJECT_NAME}-asg"
  vpc_zone_identifier = var.PUBLIC_SUBNET_IDS
  launch_template {
    name = aws_launch_template.launch_template.name
    version = "$Latest"
  }

  desired_capacity          = 2
  min_size                  = 2
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"
}