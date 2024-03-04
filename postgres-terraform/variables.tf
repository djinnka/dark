variable "region" {
    default = "eu-west-1"
}
variable "workspace" {
    default = "dark"
}
variable "password" {
    default = "dark"
}
variable "aws_type" {
    default = "t2.micro"
}
variable "aws_ami" {
    default = "ami-0ef9e689241f0bb6e"
}
variable "ssh_key" {
    type    = string
    default = "dark"
}