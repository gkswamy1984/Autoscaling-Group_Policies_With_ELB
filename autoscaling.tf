resource "aws_launch_configuration" "esafe" {
  name_prefix                 = "esafe-launchconfig"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.esafe-demo.key_name}"
  security_groups             = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = "true"
}

resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.esafe.name}-asg"

  min_size         = 1
  desired_capacity = 1
  max_size         = 4

  health_check_type = "ELB"
  load_balancers = [
    "${aws_elb.esafe_elb.id}"
  ]

  launch_configuration = "${aws_launch_configuration.esafe.name}"
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"
  vpc_zone_identifier = flatten(["${aws_subnet.public-subnet1.id}", "${aws_subnet.public-subnet2.id}"])

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}
