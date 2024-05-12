module "vpc" {
  source = "./modules/vpc"
  AWS_REGION = var.AWS_REGION

}

module "ec2" {
  source = "./modules/ec2"
  PROJECT_NAME = var.PROJECT_NAME
  VPC_ID = module.vpc.vpc_id
  PUBLIC_SUBNET_IDS = module.vpc.public_subnet_ids
  EC2_IMAGE_ID = data.aws_ami.ec2_image_id.image_id
  KEY_PAIR_NAME = data.aws_key_pair.web-app.key_name
  EC2_INSTANCE_TYPE = var.EC2_INSTANCE_TYPE
}