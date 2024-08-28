variable "vpc_configuration" {
  type = object({
    cidr_block           = string
    instance_tenancy     = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
    tags                 = map(string)
  })
  description = "vpc configuration"
  default = {
    cidr_block           = "10.0.0.0/16"
    instance_tenancy     = "default"
    enable_dns_hostnames = true
    enable_dns_support   = false
    tags = {
      Name        = "lt-vpc",
      Environment = "dev"
    }
  }
}


variable "private_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
  description = "private subnets"
  default = [{
    cidr_block        = "10.0.2.0/24"
    availability_zone = "ap-south-1a"
    tags = {
      Name        = "app-1"
      Environment = "dev"
    }
    }, {
    cidr_block        = "10.0.3.0/24"
    availability_zone = "ap-south-1b"
    tags = {
      Name        = "app-2"
      Environment = "dev"
    }
  }]
}

variable "public_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
  description = "public subnets"
  default = [{
    cidr_block        = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    tags = {
      Name        = "web-1"
      Environment = "dev"
    }
    }, {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-south-1b"
    tags = {
      Name        = "web-2"
      Environment = "dev"
    }
  }]
}

variable "is_nat_gateway_required" {
  type        = bool
  description = "is nat gateway required"
  default     = false
}
