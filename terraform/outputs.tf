output "cf_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "Domain name corresponding to the distribution"
}
