resource "aws_ecs_cluster" "main" {
  name = "${var.basename}-${var.env}"
  capacity_providers = ["FARGATE", "FARGATE_SPOT", aws_ecs_capacity_provider.provider.name]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.basename}-${var.env}"
    },
  )
  # TODO: Logs, KMS
}
