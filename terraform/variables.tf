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
  default     = "AAKIA6CY4IDLE76WREF6P"
}



variable "secret_key" {
  description = "secret_key"
  type        = string
  sensitive   = true
  default     = "dNix2r+ep62KzsWBzFyXWlVgIjtdMqm3KzQlPmND"
}