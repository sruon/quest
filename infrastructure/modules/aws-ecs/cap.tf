resource "aws_ecs_capacity_provider" "provider" {
  name = "${var.basename}-${var.env}"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.autoscaling_group_arn
  }

}
