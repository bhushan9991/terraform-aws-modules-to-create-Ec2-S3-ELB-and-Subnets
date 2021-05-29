##AWS
variable "aws_region" {
  description = "Aws Region"
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
}

variable "image_id" {
  description = "image-id"
}
variable "instance_type" {
  description = "instance-type"
}
variable "ec2_key_pair_name" {
  description = "ecs-key-pair-name"
}

## Environment configuration
variable "env" {
  description = "Provide a environment for Tags. i.e - dev/prod/stage"
}
