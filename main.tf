terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.8"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

#resource "aws_instance" "example" {
#  ami           = "ami-0a669382ea0feb73a"
#  instance_type = "t2.micro"
#  key_name = "keyPair1"
#  security_groups = ["webServerGroup_eu-west-2"]
#}



resource "aws_launch_template" "webServerTemplate2" {
    name = "webServerTemplate2"
    image_id = "ami-0c2045f8db5e396d8"
    instance_type = "t2.micro"
    key_name = "keyPair1"
}

resource "aws_placement_group" "pg1" {
    name = "pg1"
    strategy = "spread"
}

resource "aws_autoscaling_group" "asg1" {
    name ="asg1"
    max_size = 2
    min_size = 1
    desired_capacity = 2
    health_check_grace_period = 300
    health_check_type = "ELB"
    force_delete = true
    placement_group = aws_placement_group.pg1.id
    vpc_zone_identifier = ["subnet-171a816d","subnet-b58f26f9"]

    launch_template {
        id = aws_launch_template.webServerTemplate2.id
        version = "$Latest"
    }
}