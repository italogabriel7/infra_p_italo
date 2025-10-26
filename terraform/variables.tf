variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_prefix" {
  type        = string
  description = "Prefixo do bucket S3 (o sufixo aleatório será adicionado automaticamente)."
  default     = "infra-prova"
}