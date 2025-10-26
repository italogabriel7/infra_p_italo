output "bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}

output "iam_user" {
  value = aws_iam_user.lab_user.name
}