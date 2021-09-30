data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "task_lg" {
  name              = "${var.basename}-${var.env}"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "app" {
  family = "${var.basename}-${var.env}"

  container_definitions = <<EOF
[
  {
    "name": "${var.basename}-${var.env}",
    "image": "${var.registry}:${var.branch}",
    "cpu": 0,
    "memory": 128,
    "environment": ${jsonencode(var.task_env)},
    "portMappings": [
       {
          "containerPort": ${var.task_port}
       }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-group": "${var.basename}-${var.env}",
        "awslogs-stream-prefix": "app"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "app" {
  name            = "${var.basename}-${var.env}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count = 10

  load_balancer {
    target_group_arn = var.tg_arn
    container_name = "${var.basename}-${var.env}"
    container_port = var.task_port
  }
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  placement_constraints {
    type       = "memberOf"
//    expression = "attribute:ecs.availability-zone in ${jsonencode(var.azs)}"
    expression = "attribute:ecs.availability-zone in [us-east-2a, us-east-2b, us-east-2c]"
  }
  depends_on = [aws_iam_service_linked_role.ecs] # AWS will complain if the servicelinkedrole doesn't exist
}
