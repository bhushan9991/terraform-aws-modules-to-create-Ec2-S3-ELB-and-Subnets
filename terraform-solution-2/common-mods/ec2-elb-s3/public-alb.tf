## Security Group for ELB
resource "aws_security_group" "elb" {
  name = "test_elb_sg"
  vpc_id      = var.vpc_id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "test_elb_sg"
    product_id = "test_product"
    env        = var.env
  }
}

### Creating ELB
resource "aws_elb" "elb" {
  name                = "test-elb"
  security_groups     = ["${aws_security_group.elb.id}"]
  subnets             = "${data.aws_subnet_ids.default.ids}"
  listener {
    instance_port     = 443
    instance_protocol = "https"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTPS:443/health"
    interval            = 30
  }
  instances                   = ["${aws_instance.instance.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags = {
    Name = "test_elb"
    product_id = "test_product"
    env        = var.env
  }
}
