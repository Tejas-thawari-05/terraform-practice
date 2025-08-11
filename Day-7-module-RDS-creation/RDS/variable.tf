variable "db_subnet_group_name" {
    default = ""
}
variable "subnet_ids" {
  type = list(string)
}

variable "sg_name" {
    default = ""
}
variable "vpc_id" {
    default = ""
}
variable "allowed_sg_ids" {
  type = list(string)
}

variable "allocated_storage" {
  default = ""
}

variable "engine_version" {
  default = ""
}

variable "instance_class" {
  default = ""
}

variable "db_name" {
    default = ""
}
variable "username" {
    default = ""
}
variable "password" {
    default = ""
}
variable "publicly_accessible" {
  default = true
}

variable "db_instance_name" {
    default = ""
}
