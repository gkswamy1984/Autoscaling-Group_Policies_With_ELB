resource "aws_elb" "esafe_elb" {
  name                      = "esafe-elb"
  security_groups           = ["${aws_security_group.sgweb.id}"]
  subnets                   = flatten(["${aws_subnet.public-subnet1.id}", "${aws_subnet.public-subnet2.id}"])
  cross_zone_load_balancing = true
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 300
    target              = "HTTP:80/"
  }
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }
}
