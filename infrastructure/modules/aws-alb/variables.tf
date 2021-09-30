variable "basename" {
  type = string
}
variable "env" {
  type = string
}

variable "common_tags" {
  type = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}
