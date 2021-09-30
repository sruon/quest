data "template_file" "user_data" {
  template = file("${path.module}/files/user-data.sh")

  vars = {
    cluster_name = "${var.basename}-${var.env}"
  }
}
