variable "PROJECT_NAME" {}
variable "VPC_ID" {}
variable "PUBLIC_SUBNET_IDS" {
    type = list(string)
}

variable "EC2_IMAGE_ID" {}

variable "KEY_PAIR_NAME" {}

variable "EC2_INSTANCE_TYPE" {}
