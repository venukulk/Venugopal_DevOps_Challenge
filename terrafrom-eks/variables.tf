variable "AWS_REGION" {
  type = string
}

variable "AMIS" {
  type = map(any)
  default = {
    "us-east-1" = "ami-05ffe3c48a9991133"
  }
}

variable "VPC_CIDR_BLOCK" {
  type = string
}

variable "PRIVATE_SUBNET_CIDR_BLOCK" {
  type = string
}

variable "PRIVATE_SUBNET1_CIDR_BLOCK" {
  type = string
}

variable "PRIVATE_SUBNET_AZ" {
  type = string
}

variable "PUBLIC_SUBNET_CIDR_BLOCK" {
  type = string
}

variable "PUBLIC_SUBNET1_CIDR_BLOCK" {
  type = string
}

variable "PUBLIC_SUBNET_AZ" {
  type = string
}

variable "KEY_PAIR" {}

variable "EKS_CLUSTER_NAME" {}

variable "NODE_GROUP_NAME" {}

variable "NODE_GROUP_INSTANCE_TYPES" {
  type = list(any)
}

variable "NODE_GROUP_DESIRED_SIZE" {
  type = number
}

variable "NODE_GROUP_MAX_SIZE" {
  type = number
}

variable "NODE_GROUP_MIN_SIZE" {
  type = number
}
