provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.aws_eks.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.aws_eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.aws_eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes = {
    config_path = null

    host                   = aws_eks_cluster.aws_eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.aws_eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
