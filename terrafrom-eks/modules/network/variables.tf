variable "AWS_REGION" {
type = string
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

variable "EKS_CLUSTER_NAME" {}
