resource "aws_alb" "alb" {
  name = "${var.basename}-${var.env}"
  internal = false
  load_balancer_type = "application"
  subnets = var.public_subnets
  security_groups = [aws_security_group.sg.id]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.basename}-${var.env}"
    },
  )
}
