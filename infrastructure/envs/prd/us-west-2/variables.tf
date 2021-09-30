variable "base_name" {
  type = string
  default = "rearc"
}

variable "env" {
  type = string
  default = "prd"
}

variable "task_port" {
  type = number
  default = 3000
}
variable "task_env" {
  type = list(object({
    name  = string
    value = string
  }))
  default = [
  {
    name  = "SECRET_WORD"
    value = "TwelveFactor"
  }
]
}
