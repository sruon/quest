output "alb_arn" {
  value = aws_alb.alb.arn
}

output "tg_arn" {
  value = aws_lb_target_group.tg.arn
}
