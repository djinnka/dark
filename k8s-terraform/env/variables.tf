variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "my_public_ip_cidr" {
  default = "XXX.XXX.XXX.XXX/XX"
}

variable "vpc_cidr_block" {
  default = "10.50.0.0/16"
}

variable "environment" {
  default = "dev"
}

variable "certmanager_email_address" {
  default = "xxxxx@xxx.xxx"
}

variable "ssk_key_pair_name" {
  default = "dark"
}