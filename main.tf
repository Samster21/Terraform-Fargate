terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "sample_cluster" {
    name = "terra_cluster"

    setting{
        name = "containerInsights"
        value = "disabled"
    } 
}


resource "aws_ecs_task_definition" "sample_task" {
  family = "Isaac_tasks"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = "256"
  memory = "512"
  container_definitions = <<TASK_DEFINITION
  [
        {
            "name": "fargate-app", 
            "image": "public.ecr.aws/docker/library/httpd:latest", 
            "portMappings": [
                {
                    "containerPort": 80, 
                    "hostPort": 80, 
                    "protocol": "tcp"
                }
            ], 
            "essential": true, 
            "entryPoint": [
                "sh",
		"-c"
            ], 
            "command": [
                "/bin/sh -c \"echo '<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground\""
            ]
        }
    ]
  TASK_DEFINITION

}

resource "aws_ecs_service" "sample_service" {
  name = "terra_service"
  cluster = aws_ecs_cluster.sample_cluster.arn
  task_definition = aws_ecs_task_definition.sample_task.arn
  desired_count = 1
  launch_type = "FARGATE"
  scheduling_strategy = "REPLICA"
  network_configuration {
    subnets = ["subnet-064838b57f876577d" , "subnet-09a90c11043609da6"] 
    security_groups = ["sg-06a57f0a3fae819bc"]
    assign_public_ip = "true"
  }
  

}

