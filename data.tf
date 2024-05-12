data "aws_ami" "ec2_image_id" {
#   executable_users = ["self"]
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240423"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_key_pair" "web-app" {
#   key_name           = "web-app-key"
#   include_public_key = true

  filter {
    name   = "key-name"
    values = ["web-app-key"]
  }
}