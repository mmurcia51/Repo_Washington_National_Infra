output "cf_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "Domain name corresponding to the distribution"
}

output "name_ecs" {
  description = "Nombre ECS"
  value       = aws_ecs_cluster.washington_ecs.name
}

output "name_task_def" {
  description = "Nombre Task definitio"
  value       = aws_ecs_task_definition.washington_tsk.family
}


output "name_alb" {
  description = "Nombre alb"
  value       = aws_alb.washington_alb.name
}

