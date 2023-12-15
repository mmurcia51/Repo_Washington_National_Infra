# Creación de un Application Load Balancer (ALB)
resource "aws_alb" "washington_alb" {
  name                       = "washington-alb"                               # Nombre del ALB
  internal                   = false                                          # No es interno
  load_balancer_type         = "network"                                      # Tipo de balanceador de carga de aplicación
  subnets                    = [aws_subnet.subnet1.id, aws_subnet.subnet2.id] # Subnets en las que se desplegará el ALB
  security_groups            = [aws_security_group.nat_security_group.id]
  enable_deletion_protection = false # No habilitar la protección contra eliminación

  tags = {
    Name = "washington-alb" # Etiqueta para identificar el recurso
  }
}

# Creación del Grupo de Destino del ALB
resource "aws_alb_target_group" "washington_target_group" {
  name        = "washingtonnattargetgroup" # Nombre del grupo de destino
  port        = 80                         # Puerto al que el ALB enviará el tráfico
  protocol    = "TCP"                      # Protocolo utilizado 
  vpc_id      = aws_vpc.washington_vpc.id  # ID de la VPC
  target_type = "ip"

  health_check {
    path                = "/" # Ruta de la comprobación de salud
    interval            = 30  # Intervalo entre comprobaciones de salud
    timeout             = 10  # Tiempo de espera de la comprobación de salud
    healthy_threshold   = 3   # Número de comprobaciones de salud exitosas para considerar sano
    unhealthy_threshold = 3   # Número de comprobaciones de salud fallidas para considerar no saludable
  }

  tags = {
    Name = "washington_target_group" # Etiqueta para identificar el recurso
  }
}

# Configuración del Listener del ALB
resource "aws_alb_listener" "washington_listener" {
  load_balancer_arn = aws_alb.washington_alb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_alb_target_group.washington_target_group.arn
    type             = "forward"

  }

  tags = {
    Name = "washington-listener"
  }
}


# Creación del Grupo de Seguridad
resource "aws_security_group" "nat_security_group" {
  vpc_id = aws_vpc.washington_vpc.id   # ID de la VPC
  name   = "washington-security-group" # Nombre del grupo de seguridad
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

# # Regla de Ingreso HTTP para el Grupo de Seguridad
# resource "aws_security_group_rule" "allow_ingress_http" {
#   security_group_id = aws_security_group.nat_security_group.id # ID del grupo de seguridad
#   type              = "ingress"                                # Tipo de regla de seguridad (entrada)
#   from_port         = 80                                       # Puerto de inicio (HTTP)
#   to_port           = 80                                       # Puerto de destino (HTTP)
#   protocol          = "tcp"                                    # Protocolo (TCP)
#   cidr_blocks       = ["0.0.0.0/0"]                            # Rango de IP permitido (puedes ajustarlo según tus necesidades)
# }

# Regla de Ingreso para todo el tráfico desde otro Grupo de Seguridad
resource "aws_security_group_rule" "allow_ingress_all_traffic" {
  security_group_id        = aws_security_group.nat_security_group.id # ID del grupo de seguridad destino
  type                     = "ingress"                                # Tipo de regla de seguridad (entrada)
  from_port                = 0                                        # Puerto de inicio (puedes ajustarlo según tus necesidades)
  to_port                  = 0                                        # Puerto de destino (puedes ajustarlo según tus necesidades)
  protocol                 = "-1"                                     # Protocolo (-1 significa todos los protocolos)
  source_security_group_id = aws_security_group.nat_security_group.id # ID del grupo de seguridad de origen
}


# # Regla de Ingreso para todo el tráfico desde otro Grupo de Seguridad
# resource "aws_security_group_rule" "allow_ingress_all_traffic1" {
#   security_group_id        = aws_security_group.default.id            # ID del grupo de seguridad destino
#   type                     = "ingress"                                # Tipo de regla de seguridad (entrada)
#   from_port                = 0                                        # Puerto de inicio (puedes ajustarlo según tus necesidades)
#   to_port                  = 0                                        # Puerto de destino (puedes ajustarlo según tus necesidades)
#   protocol                 = "-1"                                     # Protocolo (-1 significa todos los protocolos)
#   source_security_group_id = aws_security_group.nat_security_group.id # ID del grupo de seguridad de origen
# }

# # Regla de Ingreso HTTP para el Grupo de Seguridad
# resource "aws_security_group_rule" "allow_ingress_http1" {
#   security_group_id = aws_security_group.default.id # ID del grupo de seguridad
#   type              = "ingress"                     # Tipo de regla de seguridad (entrada)
#   from_port         = 80                            # Puerto de inicio (HTTP)
#   to_port           = 80                            # Puerto de destino (HTTP)
#   protocol          = "tcp"                         # Protocolo (TCP)
#   cidr_blocks       = ["0.0.0.0/0"]                 # Rango de IP permitido (puedes ajustarlo según tus necesidades)
# }
