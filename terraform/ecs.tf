# Creacion Cluster
resource "aws_ecs_cluster" "washington_ecs" {
  name = "washington-ecs"
}


# resource "aws_ecs_cluster_capacity_provider" "washington_nat_ecs_cluster" {
#   # name = "FARGATE"  
#   capacity_provider_name = "FARGATE"
# }

#Asociamos el cluster - capacity 
resource "aws_ecs_cluster_capacity_providers" "washington_nat_ecs_cluster" {
  cluster_name = aws_ecs_cluster.washington_ecs.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 10
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "washington_tsk" {
  family                   = "washington_family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name      = "appangular"
      image     = "emmatellez/appangular:1.0"
      cpu       = 256
      memory    = 512
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

    }
  ])

}





# Creacion Servicio
resource "aws_ecs_service" "washington_ecs_srv" {
  name            = "washington-ecs-srv"
  cluster         = aws_ecs_cluster.washington_ecs.id
  task_definition = aws_ecs_task_definition.washington_tsk.id
  desired_count   = 1
  network_configuration {

    subnets          = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    security_groups  = [aws_security_group.nat_security_group.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.washington_target_group.id
    container_name   = "appangular"
    container_port   = 80

  }

}
