terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.64.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
    source = "../.."
    vpc_configuration = {
        cidr_block = "10.0.0.0/16"
        instance_tenancy = "default"
        enable_dns_hostnames = true
        enable_dns_support = false
        tags = {
          Name = "three-tier-network"
          Environment = "dev"
        }

    }
    private_subnets = [
        {
            cidr_block = "10.0.1.0/24"
            availability_zone = "ap-south-1a"
            tags = {
                Name = "app-1"
                Environment = "dev"
            }
        },
        {
            cidr_block = "10.0.2.0/24"
            availability_zone = "ap-south-1a"
            tags = {
                Name = "db-1"
                Environment = "dev"
            }
        }
    ]
    public_subnets = [
        {
            cidr_block = "10.0.0.0/24"
            availability_zone = "ap-south-1a"
            tags = {
                Name = "web-1"
                Environment = "dev"
            }
        }
    ]
    is_nat_gateway_required = false
  
}