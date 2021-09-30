module "ec2_profile" {
  source = "../ecs-instance-profile"

  name = "${var.basename}-${var.env}"

   tags = merge(
    var.common_tags,
    {
      Name = "${var.basename}-${var.env}"
    },
  )
}
resource "aws_security_group" "sg" {
  name = "${var.basename}-${var.env}-ecs"
  description = "Allow access over HTTPS"
  vpc_id = var.vpc_id


  tags = merge(
    var.common_tags,
    {
      Name = "${var.basename}-${var.env}-ecs"
    },
  )
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

module "asg" {
  source  = "../aws-asg"

  name = "${var.basename}-${var.env}"

  # Launch configuration
  lc_name   = "${var.basename}-${var.env}"
  use_lc    = true
  create_lc = true

  image_id                  = data.aws_ami.amazon_linux_ecs.id
  instance_type             = "t2.micro"
  security_groups           = [aws_security_group.sg.id]
  iam_instance_profile_name = module.ec2_profile.iam_instance_profile_id
  user_data                 = data.template_file.user_data.rendered

  # Auto scaling group
  vpc_zone_identifier       = var.private_subnets
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 10
  desired_capacity          = 5
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = var.env
      propagate_at_launch = true
    },
    {
      key                 = "Cluster"
      value               = "${var.basename}-${var.env}"
      propagate_at_launch = true
    },
  ]
}
