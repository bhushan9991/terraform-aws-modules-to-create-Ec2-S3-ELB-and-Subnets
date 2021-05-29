##AWS
variable "aws_region" {
  description = "Aws Region"
}

## VPC_ID
variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
}

## Environment configuration
variable "env" {
  description = "Provide a environment for Tags. i.e - dev/prod/stage"
}
