variable "environment" {
  description = "The environment name (e.g., development, production)"
  type        = string
}

variable "region" {
  description = "AWS region for the deployment"
  type        = string
}

variable "app_name" {
  description = "The name of the Elastic Beanstalk application"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the Elastic Beanstalk environment"
  default     = "t2.micro"
  type        = string
}

variable "tags" {
  description = "Tags to associate with AWS resources"
  type        = map(string)
  default     = {}
}

variable "env_variables" {
  description = "Env variables to be passed to the flask app"
  type        = map(string)
  default     = {}
}
