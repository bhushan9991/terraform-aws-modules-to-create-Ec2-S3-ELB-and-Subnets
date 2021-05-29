data "aws_subnet_ids" "default" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = ["subnet_1"]
  }
}

#Create an EC2 instance and a IAM role with s3 write access.
resource "aws_iam_role" "test_role" {
  name = "test_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = "${aws_iam_role.test_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:ListBucket"
          ],
          "Resource": [
              "arn:aws:s3:::test_bucket"
          ]
      },
      {
          "Effect": "Allow",
          "Action": [
              "s3:PutObject",
              "s3:PutObjectAcl"
          ],
          "Resource": [
              "arn:aws:s3:::test_bucket/*"
          ]
      }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "${aws_iam_role.test_role.name}"
}

resource "aws_security_group" "sg" {
  name        = "test_sg_1"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    ipv6_cidr_blocks  = ["::/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
      Name       = "test_sg_1"
      product_id = "test_product"
      env        = var.env
  }
}

resource "aws_instance" "instance" {
  ami                  = var.image_id
  instance_type        = var.instance_type
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
  key_name             = var.ec2_key_pair_name
  subnet_id            = flatten(data.aws_subnet_ids.default.ids)[0]
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
      Name       = "test_product"
      product_id = "test_product"
      env        = var.env
  }
}
