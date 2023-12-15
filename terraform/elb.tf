# Creación de un Application Load Balancer (ALB)
resource "aws_alb" "washington-nat_alb" {
  name               = "washington-nat-alb"                           # Nombre del ALB
  internal           = false                                          # No es interno
  load_balancer_type = "application"                                  # Tipo de balanceador de carga de aplicación
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id] # Subnets en las que se desplegará el ALB

  enable_deletion_protection = false # No habilitar la protección contra eliminación

  tags = {
    Name = "washington-nat-alb" # Etiqueta para identificar el recurso
  }
}

# Creación del Grupo de Destino del ALB
resource "aws_alb_target_group" "washington-nat_target_group" {
  name        = "washington-nat-target-group" # Nombre del grupo de destino
  port        = 80                            # Puerto al que el ALB enviará el tráfico
  protocol    = "TCP"                         # Protocolo utilizado 
  vpc_id      = aws_vpc.washington-nat_vpc.id # ID de la VPC
  target_type = "ip"

  health_check {
    path                = "/" # Ruta de la comprobación de salud
    interval            = 30  # Intervalo entre comprobaciones de salud
    timeout             = 10  # Tiempo de espera de la comprobación de salud
    healthy_threshold   = 3   # Número de comprobaciones de salud exitosas para considerar sano
    unhealthy_threshold = 3   # Número de comprobaciones de salud fallidas para considerar no saludable
  }

  tags = {
    Name = "washington-nat-target-group" # Etiqueta para identificar el recurso
  }
}

# Configuración del Listener del ALB
resource "aws_alb_listener" "washington-nat_listener" {
  load_balancer_arn = aws_alb.washington-nat_alb.arn # ARN del ALB
  port              = 80                             # Puerto que escucha el ALB
  protocol          = "HTTP"                         # Protocolo utilizado

  default_action {
    target_group_arn = aws_alb_target_group.washington-nat_target_group.arn # ARN del grupo de destino
    type             = "fixed-response"                                     # Tipo de acción predeterminada

    fixed_response {
      content_type = "text/plain" # Tipo de contenido de la respuesta fija
      status_code  = "200"        # Código de estado de la respuesta fija
      message_body = "OK"         # Cuerpo del mensaje de la respuesta fija
    }
  }

  tags = {
    Name = "washington-nat-listener" # Etiqueta para identificar el recurso
  }
}

# Creación del Grupo de Seguridad
resource "aws_security_group" "nat_security_group" {
  vpc_id = aws_vpc.washington-nat_vpc.id   # ID de la VPC
  name   = "washington-nat-security-group" # Nombre del grupo de seguridad

  tags = {
    Enviroment = "Produccion" # Etiqueta para identificar el entorno
  }
}

# Regla de Ingreso para la Subnet 1
resource "aws_security_group_rule" "allow_ingress_subnet1" {
  security_group_id = aws_security_group.nat_security_group.id # ID del grupo de seguridad
  type              = "ingress"                                # Tipo de regla de seguridad (entrada)
  from_port         = 0                                        # Puerto de inicio
  to_port           = 8080                                     # Puerto de destino
  protocol          = "-1"                                     # Protocolo (-1 significa todos los protocolos)
  cidr_blocks       = [aws_subnet.subnet1.cidr_block]          # Bloque CIDR de la Subnet 1
}

# Regla de Ingreso para la Subnet 2
resource "aws_security_group_rule" "allow_ingress_subnet2" {
  security_group_id = aws_security_group.nat_security_group.id # ID del grupo de seguridad
  type              = "ingress"                                # Tipo de regla de seguridad (entrada)
  from_port         = 0                                        # Puerto de inicio
  to_port           = 8080                                     # Puerto de destino
  protocol          = "-1"                                     # Protocolo (-1 significa todos los protocolos)
  cidr_blocks       = [aws_subnet.subnet2.cidr_block]          # Bloque CIDR de la Sub
}
