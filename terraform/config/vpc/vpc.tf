module "module "vpc" {
    source = "../../modules/vpc"
    vpc_cidr_block = "10.55.0.0"
    vpc_name = "dev"
    vpc_environment = "dev"
}
