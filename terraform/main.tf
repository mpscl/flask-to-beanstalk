resource "aws_elastic_beanstalk_application" "app" {
  name = var.app_name
}

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "${var.app_name}-${var.environment}"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v4.0.5 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_profile.name
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

resource "aws_iam_role" "beanstalk_role" {
  name               = "${var.environment}-${var.app_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "beanstalk_profile" {
  name = "${var.environment}-${var.app_name}-instance-profile"
  role = aws_iam_role.beanstalk_role.name
}

resource "aws_iam_role_policy_attachment" "beanstalk_role_policy" {
  role       = aws_iam_role.beanstalk_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.environment}-${var.app_name}-bucket"
  tags   = var.tags
}
