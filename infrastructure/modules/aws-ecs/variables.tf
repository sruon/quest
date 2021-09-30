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

variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "security_group" {
  type = string
}

variable "registry" {
  type = string
}

variable "branch" {
  type = string
}

variable "tg_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "task_env" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "task_port" {
  type = number
}
