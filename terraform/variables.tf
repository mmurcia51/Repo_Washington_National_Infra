variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "ecs_execution_role_name" {
  description = "Name of the ECS Execution Role"
  default     = "washington-nat-ecs-execution-role"
}



# Definición variables
/*
variable "buckets_s3" {
  description = "buckets S3"
  type        = string
}
*/
