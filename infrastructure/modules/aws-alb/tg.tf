resource "aws_lb_target_group" "tg" {
  name = "${var.basename}-${var.env}"
  port = 3000
  protocol = "HTTP"
  vpc_id = var.vpc_id
}
