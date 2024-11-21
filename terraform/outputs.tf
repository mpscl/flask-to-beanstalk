output "environment_url" {
  description = "The URL of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.env.cname
}

output "environment_arn" {
  description = "The ARN of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.env.arn
}
