module "s3-bukcet" {
  source = "../../common-mods/s3/"

  aws_region                  = "${var.aws_region}"
  vpc_id                      = "${var.vpc_id}"
  env                         = "${var.env}"
}
