terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terafrom-devops"
    dynamodb_table = "tf-state-lock"
    key            = "terrafrom.tfstate"
    region         = "us-east-1"
  }
}