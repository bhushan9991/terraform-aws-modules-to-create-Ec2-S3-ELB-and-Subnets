module "ec2-instance" {
  source = "../../common-mods/ec2/"

  aws_region                  = "${var.aws_region}"
  vpc_id                      = "${var.vpc_id}"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  ec2_key_pair_name           = "${var.ec2_key_pair_name}"
  env                         = "${var.env}"
}
