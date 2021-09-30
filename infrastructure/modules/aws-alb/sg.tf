resource "aws_security_group" "sg" {
  name = "${var.basename}-${var.env}"
  description = "Allow access over HTTPS"
  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.basename}-${var.env}"
    },
  )
}

resource "aws_security_group_rule" "inghttps" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
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
