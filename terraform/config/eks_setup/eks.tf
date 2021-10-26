module "eks_setup" {
    source = "../../modules/eks_setup"
    vpc_id = data.aws_vpc.vpc.id
    subnets = local.subnets[terraform.workspace]
    cluster_name = "factory"
    subnets_public = local.subnets_public[terraform.workspace]
}