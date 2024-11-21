resource "aws_elastic_beanstalk_application" "app" {
  name = var.app_name
}

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "${var.environment}-${var.app_name}-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.1 running Python 3.12"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  dynamic "setting" {
    for_each = var.env_variables
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }
}

resource "aws_iam_instance_profile" "beanstalk_profile" {
  name = "${var.environment}-${var.app_name}-instance-profile"
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.environment}-${var.app_name}-bucket"
  tags   = var.tags
}
