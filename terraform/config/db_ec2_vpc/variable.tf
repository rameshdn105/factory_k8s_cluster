variable "vpc_id" {
    type = string
}

variable "subnets" {
    type = list
}

variable "subnets_public" {
    type = list
}

variable "aws_region" {
    type = string
    default = "eu-west-1"
}
