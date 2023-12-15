variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "ecs_execution_role_name" {
  description = "Name of the ECS Execution Role"
  default     = "washington-nat-ecs-execution-role"
}

variable "access_key" {
  description = "access_key"
  type        = string
  sensitive   = true
  default     = "AKIA6CY4IDLETEVNMFW4"
}

# Definición variables
/*
variable "buckets_s3" {
  description = "buckets S3"
  type        = string
}
*/
variable "secret_key" {
  description = "secret_key"
  type        = string
  sensitive   = true
  default     = "tPIkyqbuSpak88k2Gq6eVg0pLcOjqMuPH8e33fvH"
}
