output "bucket_1_name" {
  description = "The name of the S3 bucket that is being used to store the Terraform state file"
  value       = aws_s3_bucket.bucket_1.bucket
}

output "log_bucket_1_name" {
  description = "The name of the S3 bucket that is being used to store the Terraform state file"
  value       = aws_s3_bucket.log_bucket_1.bucket
}

output "keycloak_external_url" {
  description = "URL on which Keycloak will be reachable"
  value       = var.keycloak_external_url
}

output "rds_1_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.db_instance_1.endpoint
}

output "alb_1_dns_name" {
  description = "The address of the load balancer"
  value       = aws_lb.alb_1.dns_name
}
