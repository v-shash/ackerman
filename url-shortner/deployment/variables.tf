
variable "region" {
  type    = string
  default = "us-east-1"
}


variable "node_group_instance_type" {
  type    = string
  default = "t3.small"
}

variable "node_group_max_instances" {
  type    = number
  default = 10
}

variable "node_group_min_instances" {
  type    = number
  default = 1
}

variable "node_group_desired_instances" {
  type    = number
  default = 1
}

variable "pod_replicas" {
  type    = number
  default = 2
}