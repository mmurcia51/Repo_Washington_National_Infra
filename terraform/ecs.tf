# Creacion Cluster
resource "aws_ecs_cluster" "washington_ecs" {
  name = "washington-ecs"
}

/*
resource "aws_ecs_cluster_capacity_provider" "washington_nat_ecs_cluster" {
 # name = "FARGATE"  
  capacity_provider_name = "FARGATE"
}

#Asociamos el cluster - capacity 
resource "aws_ecs_cluster_capacity_providers" "washington_nat_ecs_cluster" {
  cluster_name = aws_ecs_cluster.washington_ecs.name

  capacity_providers = [aws_ecs_capacity_provider.washington_nat_ecs_cluster.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 10
    capacity_provider = aws_ecs_capacity_provider.washington_nat_ecs_cluster.name
  }
}
*/
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
          containerPort = 83
          hostPort      = 83
          protocol      = "tcp"
        }
      ]
    }
  ])

}





# Creacion Servicio
resource "aws_ecs_service" "washington_ecs_srv" {
  name            = "washington-ecs-srv"
  cluster         = aws_ecs_cluster.washington_ecs.id
  task_definition = aws_ecs_task_definition.washington_tsk.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    security_groups = [aws_security_group.nat_security_group.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.washington_target_group.arn
    container_name   = "appangular"
    container_port   = 83
  }

}
