# AWS Infrastructure Variables
variable "region" {
  description = "The AWS region in which the infrastructure will be deployed"
  type        = string
  default     = "eu-west-1"
}

# AWS Secrets Manager Variables
variable "db_secret_1_arn" {
  description = "The ARN of the AWS Secrets Manager secret that contains the credentials for the RDS instance"
  type        = string
  default     = "arn:aws:secretsmanager:eu-west-1:080129930438:secret:keycloak-rds-1-clsfF0"
}

variable "keycloak_secret_1_arn" {
  description = "The ARN of the AWS Secrets Manager secret that contains the credentials for the Keycloak"
  type        = string
  default     = "arn:aws:secretsmanager:eu-west-1:080129930438:secret:keycloak-1-JBbfS5"
}

# Virtual Private Cloud Variables
variable "vpc_1_cidr" {
  description = "The IP range for the Virtual Private Cloud (VPC) that will be created"
  type        = string
  default     = "10.1.0.0/16"
}

# Private Subnet Variables
variable "private_subnet_1a_cidr" {
  description = "The IP range for the private subnet that will be created within the VPC"
  type        = string
  default     = "10.1.1.0/24"
}

variable "private_subnet_1b_cidr" {
  description = "The IP range for the private subnet that will be created within the VPC"
  type        = string
  default     = "10.1.2.0/24"
}

variable "private_subnet_1c_cidr" {
  description = "The IP range for the private subnet that will be created within the VPC"
  type        = string
  default     = "10.1.3.0/24"
}

# Public Subnet Variables
variable "public_subnet_1a_cidr" {
  description = "The IP range for the public subnet that will be created within the VPC"
  type        = string
  default     = "10.1.4.0/24"
}

# Public Subnet Variables
variable "public_subnet_1b_cidr" {
  description = "The IP range for the public subnet that will be created within the VPC"
  type        = string
  default     = "10.1.5.0/24"
}

# Route Variables
variable "private_route_1_cidr" {
  description = "The IP range for the private route that will be created within the VPC"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_route_1_cidr" {
  description = "The CIDR block for the public route in the route table. This allows traffic to be directed to the internet gateway and out to the public internet"
  type        = string
  default     = "0.0.0.0/0"
}

# Subnet Group Variables
variable "subnet_group_1_name" {
  description = "The name of the DB subnet group"
  type        = string
  default     = "subnet-group-keycloak-1"
}

# Route53 Variables
variable "route53_zone_1_name" {
  description = "Domain name for the ACM certificate"
  type        = string
  default     = "heyvaldemar.net"
}

# AWS Certificate Manager Variables
variable "acm_1_certificate_1_domain_name" {
  description = "Domain name for the ACM certificate"
  type        = string
  default     = "keycloak.heyvaldemar.net"
}

# RDS Variables
variable "rds_db_instance_1_id" {
  description = "The RDS instance identifier"
  type        = string
  default     = "keycloak-db"
}

variable "rds_db_instance_1_class" {
  description = "The RDS instance class"
  type        = string
  default     = "db.m5.large"
}

variable "rds_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = true
}

variable "rds_publicly_accessible" {
  description = "Specifies whether the RDS instance is publicly accessible"
  type        = bool
  default     = false
}

variable "rds_customer_owned_ip_enabled" {
  description = "Indicates whether to enable the use of a customer-owned IP address for the RDS instance"
  type        = bool
  default     = false
}

variable "rds_engine" {
  description = "The RDS instance database engine"
  type        = string
  default     = "postgres"
}

variable "rds_engine_version" {
  description = "The version of the database engine to use for the RDS instance"
  type        = string
  default     = "16.1"
}

variable "rds_allow_major_version_upgrade" {
  description = "Specifies whether major version upgrades are allowed"
  type        = bool
  default     = false
}

variable "rds_auto_minor_version_upgrade" {
  description = "Specifies whether minor engine upgrades are applied automatically"
  type        = bool
  default     = true
}

variable "rds_apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = true
}

variable "rds_db_1_name" {
  description = "The database name"
  type        = string
  default     = "keycloakdb"
}

variable "rds_db_1_port" {
  description = "The port number on which the RDS instance should listen for connections"
  type        = number
  default     = 5432
}

variable "rds_iam_database_authentication_enabled" {
  description = "Indicates whether to enable IAM database authentication for the RDS instance"
  type        = bool
  default     = true
}

variable "rds_db_instance_1_allocated_storage" {
  description = "The amount of allocated storage for the RDS instance"
  type        = number
  default     = 200
}

variable "rds_db_instance_1_max_allocated_storage" {
  description = "The maximum amount of storage (in GB) that can be allocated to the RDS instance"
  type        = number
  default     = 1000
}

variable "rds_storage_type" {
  description = "The type of storage to use for the RDS instance (e.g., 'gp2', 'gp3', 'io1', or 'standard')"
  type        = string
  default     = "gp3"
}

variable "rds_storage_encrypted" {
  description = "Specifies whether the RDS instance is encrypted"
  type        = bool
  default     = true
}

variable "rds_performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled"
  type        = bool
  default     = true
}

variable "rds_performance_insights_retention_period" {
  description = "The amount of time, in days, to retain Performance Insights data"
  type        = number
  default     = 7
}

variable "rds_enabled_cloudwatch_logs_exports" {
  description = "A list of log types to enable for the RDS instance."
  type        = list(string)
  default     = ["postgresql", "upgrade"]
}

variable "rds_maintenance_window" {
  description = "The preferred time window for the RDS instance maintenance (in UTC)"
  type        = string
  default     = "sun:01:54-sun:02:24"
}

variable "rds_backup_window" {
  description = "The preferred time window for the RDS instance daily backups (in UTC)"
  type        = string
  default     = "23:01-00:01"
}

variable "rds_backup_retention_period" {
  description = "The number of days to retain backups"
  type        = number
  default     = 30
}

variable "rds_delete_automated_backups" {
  description = "Indicates whether to delete automated backups when the RDS instance is deleted"
  type        = bool
  default     = true
}

variable "rds_skip_final_snapshot" {
  description = "Indicates whether to skip the creation of a final DB snapshot when the RDS instance is deleted"
  type        = bool
  default     = true
}

variable "rds_network_type" {
  description = "The network type to use for the RDS instance (e.g., 'IPV4' or 'IPV6')"
  type        = string
  default     = "IPV4"
}

variable "rds_copy_tags_to_snapshot" {
  description = "Specifies whether to copy all tags from the RDS instance to snapshots of the instance"
  type        = bool
  default     = true
}

variable "rds_deletion_protection" {
  description = "Specifies whether deletion protection is enabled"
  type        = bool
  default     = true
}

# Instance Variables
variable "ec2_instance_1_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.large"
}

variable "ec2_root_volume_1_size_gb" {
  description = "The size (in GB) of the root volume for the EC2 instance"
  type        = number
  default     = 100
}

variable "ec2_root_volume_1_type" {
  description = "The type of the root volume for the EC2 instance (e.g. gp2, gp3, io1, st1, sc1)"
  type        = string
  default     = "gp3"
}

variable "ec2_root_volume_1_encryption" {
  description = "A flag to enable or disable EBS volume encryption"
  type        = bool
  default     = true
}

variable "ec2_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination"
  type        = bool
  default     = true
}

variable "ec2_monitoring" {
  description = "Whether the instance should be monitored"
  type        = bool
  default     = true
}

variable "ec2_http_tokens" {
  description = "State of token usage for Instance Metadata Service"
  type        = string
  default     = "required"
}

variable "ec2_http_put_response_hop_limit" {
  description = "The max no of hops made by the PUT response of IMDS"
  type        = number
  default     = 1
}

variable "ec2_http_endpoint" {
  description = "Whether the IMDS is available"
  type        = string
  default     = "enabled"
}

variable "ec2_availability_zone" {
  description = "The AWS Availability Zone where the EC2 instance should be deployed"
  type        = string
  default     = "eu-west-1a"
}

# Key Pair Variables
variable "key_pair_1_name" {
  description = "The name of the key pair used to authenticate with the EC2 instance"
  type        = string
  default     = "key-pair-keycloak-1"
}

# KMS Variables
variable "kms_key_1_default_retention_days" {
  description = "The default retention period in days for keys created in the KMS keyring"
  type        = number
  default     = 10
}

variable "kms_key_2_default_retention_days" {
  description = "The default retention period in days for keys created in the KMS keyring"
  type        = number
  default     = 10
}

variable "kms_key_3_default_retention_days" {
  description = "The default retention period in days for keys created in the KMS keyring"
  type        = number
  default     = 10
}

# DynamoDB Variables
variable "dynamodb_terraform_state_lock_1_billing_mode" {
  description = "The billing mode for the DynamoDB table used for Terraform state locking"
  type        = string
  default     = "PAY_PER_REQUEST"
}

# Keycloak Variables
variable "keycloak_image_tag" {
  description = "Docker image tag for the Keycloak instance"
  type        = string
  default     = "24.0.5"
}

variable "keycloak_external_url" {
  description = "URL on which Keycloak will be reachable"
  type        = string
  default     = "https://keycloak.heyvaldemar.net"
}

variable "keycloak_trusted_domain" {
  description = "URL on which Keycloak will be reachable"
  type        = string
  default     = "keycloak.heyvaldemar.net"
}
