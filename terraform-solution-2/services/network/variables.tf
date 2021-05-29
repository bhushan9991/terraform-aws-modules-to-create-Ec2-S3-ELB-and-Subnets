##AWS
variable "aws_region" {
  description = "aws Region"
  default = "eu-west-1"
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  type        = list
  description = "List of private subnet CIDR blocks"
}

variable "env" {
  description = "Provide a environment for Tags. i.e - dev/prod/stage"
}
