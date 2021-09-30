locals {
  common_tags = {
    Environment = "prd"
    ManagedBy = "terraform"
  }
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
}
