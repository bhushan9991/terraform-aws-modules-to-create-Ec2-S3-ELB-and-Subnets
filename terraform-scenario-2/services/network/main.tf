module "vpc_subnets" {
  source = "../../common-mods/network/"

  aws_region                  = "${var.aws_region}"
  vpc_id                      = "${var.vpc_id}"
  public_subnet_cidr_blocks   = "${var.public_subnet_cidr_blocks}"
  private_subnet_cidr_blocks  = "${var.private_subnet_cidr_blocks}"
  env                         = "${var.env}"
}
