environment = "development"
region      = "eu-central-1"
app_name    = "flask-app"
instance_type = "t2.micro"
env_variables = {
  FLASK_ENV = "development"
}
tags = {
  Environment = "Development"
}
