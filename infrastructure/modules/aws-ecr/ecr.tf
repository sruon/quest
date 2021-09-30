resource "aws_ecr_repository" "repo" {
  name                 = "${var.basename}-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

    tags = merge(
    var.common_tags,
    {
      Name = "${var.basename}-${var.env}"
    },
  )
}
