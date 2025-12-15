variable vpc_cidr_block{
    default = "10.0.0.0/16"
}
variable subnet_cidr_block{
    default = "10.0.0.0/24"
}
variable env_prefix {
    default = "dev"
}
variable avail_zone {
    default = "ap-southeast-2a"
}
variable region {
    default = "ap-southeast-2"
}
variable "my_ip" {
    default = "106.71.63.97/32"
}

variable "jenkins_ip" {
  default = "209.38.26.183/32"
}
variable "instance_type" {
    default = "t2.micro"
}