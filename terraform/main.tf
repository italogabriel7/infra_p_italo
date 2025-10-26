terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  required_version = ">= 1.4.0"
}

# ===== Provider =====
# Por padrão, configurado para LocalStack. Para usar AWS real:
# - Comente o bloco 'endpoints' e remova as flags skip_*.
# - Configure credenciais (aws configure) e defina var.aws_region.
provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "http://localhost:4566"
    iam = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}

# ===== Random suffix para garantir nome único do bucket =====
resource "random_id" "suffix" {
  byte_length = 4
}

# ===== Bucket S3 =====
resource "aws_s3_bucket" "app_bucket" {
  bucket        = "${var.bucket_prefix}-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name = "infra-prova-bucket"
    Env  = "lab"
  }
}

# ===== Usuário IAM com política mínima de acesso ao bucket =====
resource "aws_iam_user" "lab_user" {
  name = "infra_prova_user"
}

data "aws_iam_policy_document" "lab_user_doc" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.app_bucket.arn,
      "${aws_s3_bucket.app_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_user_policy" "lab_user_policy" {
  name   = "lab_user_policy"
  user   = aws_iam_user.lab_user.name
  policy = data.aws_iam_policy_document.lab_user_doc.json
}

# ===== Outputs =====
output "bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}

output "iam_user" {
  value = aws_iam_user.lab_user.name
}