module "aws_network" {
  source                     = "./modules/network"
  VPC_CIDR_BLOCK             = var.VPC_CIDR_BLOCK
  PRIVATE_SUBNET_CIDR_BLOCK  = var.PRIVATE_SUBNET_CIDR_BLOCK
  PRIVATE_SUBNET1_CIDR_BLOCK = var.PRIVATE_SUBNET1_CIDR_BLOCK
  PRIVATE_SUBNET_AZ          = var.PRIVATE_SUBNET_AZ
  PUBLIC_SUBNET_CIDR_BLOCK   = var.PUBLIC_SUBNET_CIDR_BLOCK
  PUBLIC_SUBNET1_CIDR_BLOCK   = var.PUBLIC_SUBNET1_CIDR_BLOCK
  PUBLIC_SUBNET_AZ           = var.PUBLIC_SUBNET_AZ
  AWS_REGION                 = var.AWS_REGION
  EKS_CLUSTER_NAME           = var.EKS_CLUSTER_NAME
}

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
{
"Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "aws_eks" {
  name     = var.EKS_CLUSTER_NAME
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = [module.aws_network.public_subnet_id, module.aws_network.public1_subnet_id, module.aws_network.private_subnet_id, module.aws_network.private1_subnet_id]
  }

  tags = {
    Name = "EKS_tuto"
  }
}


resource "aws_iam_role" "eks_nodes" {
  name = "eks-node-group-tuto"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}


resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = var.NODE_GROUP_NAME
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [module.aws_network.private_subnet_id, module.aws_network.private1_subnet_id]
  instance_types  = var.NODE_GROUP_INSTANCE_TYPES

  scaling_config {
    desired_size = var.NODE_GROUP_DESIRED_SIZE
    max_size     = var.NODE_GROUP_MAX_SIZE
    min_size     = var.NODE_GROUP_MIN_SIZE
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
