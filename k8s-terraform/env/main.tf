module "vpc" {
  region            = var.AWS_REGION
  my_public_ip_cidr = var.my_public_ip_cidr
  vpc_cidr_block    = var.vpc_cidr_block
  environment       = var.environment
  source            = "github.com/garutilorenzo/aws-terraform-examples/private-vpc"
}
output "private_subnets_ids" {
  value = module.vpc.private_subnet_ids
}
output "public_subnets_ids" {
  value = module.vpc.public_subnet_ids
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

module "k8s-cluster" {
  ssk_key_pair_name         = var.ssk_key_pair_name
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  vpc_private_subnets       = module.vpc.private_subnet_ids
  vpc_public_subnets        = module.vpc.public_subnet_ids
  vpc_subnet_cidr           = var.vpc_cidr_block
  my_public_ip_cidr         = var.my_public_ip_cidr
  create_extlb              = true
  install_nginx_ingress     = true
  efs_persistent_storage    = true
  expose_kubeapi            = true
  install_certmanager       = true
  certmanager_email_address = var.certmanager_email_address
  #source                    = "github.com/garutilorenzo/k8s-aws-terraform-cluster"
  source                    = "../"
}

output "k8s_dns_name" {
  value = module.k8s-cluster.k8s_dns_name
}

output "k8s_server_private_ips" {
  value = module.k8s-cluster.k8s_server_private_ips
}

output "k8s_workers_private_ips" {
  value = module.k8s-cluster.k8s_workers_private_ips
}

module "metallb" {
  source  = "colinwilson/metallb/kubernetes"
  version = "0.1.7"
}
#module "metallb" {
#  source                  = "../modules/metallb"
#}
