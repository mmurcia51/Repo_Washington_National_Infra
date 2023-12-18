provider "aws" {
  region     = "us-west-2"
  alias      = "virginia"
}
# Creación de la VPC
resource "aws_vpc" "washington_vpc" {
  cidr_block           = "10.0.0.0/22" # Rango de direcciones IP para la VPC
  enable_dns_support   = true          # Habilitar soporte DNS en la VPC
  enable_dns_hostnames = true          # Habilitar nombres de host DNS en la VPC

  tags = {
    Name       = "washington-vpc" # Etiqueta para identificar la VPC
    Enviroment = "Produccion"
  }
}

# Creación de la Subnet 1
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.washington_vpc.id
  cidr_block              = "10.0.1.0/24" # Rango de direcciones IP para la Subnet 1
  availability_zone       = "us-west-2a"  # Zona de disponibilidad de AWS
  map_public_ip_on_launch = true          # Asignar IP pública a instancias lanzadas en la Subnet

  tags = {
    Name       = "washington-subnet-1" # Etiqueta para identificar la Subnet 1
    Enviroment = "Produccion"
  }
}

# Creación de la Subnet 2
resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.washington_vpc.id
  cidr_block              = "10.0.2.0/24" # Rango de direcciones IP para la Subnet 2
  availability_zone       = "us-west-2b"  # Zona de disponibilidad de AWS
  map_public_ip_on_launch = true          # Asignar IP pública a instancias lanzadas en la Subnet

  tags = {
    Name       = "washington-subnet-2" # Etiqueta para identificar la Subnet 2
    Enviroment = "Produccion"
  }
}


# Crear Internet Gateway
resource "aws_internet_gateway" "washington_igw" {
  vpc_id = aws_vpc.washington_vpc.id # Asociar el Internet Gateway con la VPC creada anteriormente

  tags = {
    Name = "washington-igw" # Etiqueta para identificar el Internet Gateway
  }
}


# Creación de la Tabla de Ruteo para la Subnet 1
resource "aws_route_table" "route_table_subnet" {
  vpc_id = aws_vpc.washington_vpc.id

  tags = {
    Name       = "washington-route-table-subnet-1" # Etiqueta para identificar la tabla de ruteo
    Enviroment = "Produccion"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.washington_igw.id
  }
}

# Asociación de la Tabla de Ruteo con la Subnet
resource "aws_main_route_table_association" "association_subnet" {
  vpc_id         = aws_vpc.washington_vpc.id
  route_table_id = aws_route_table.route_table_subnet.id
}


# # Creación de la Tabla de Ruteo para la Subnet 2
# resource "aws_route_table" "route_table" {
#   vpc_id = aws_vpc.washington_vpc.id

#   tags = {
#     Name       = "washington-route-table-subnet-2" # Etiqueta para identificar la tabla de ruteo
#     Enviroment = "Produccion"
#   }
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.washington_igw.id

#   }
# }

# # Asociación de la Tabla de Ruteo con la Subnet 2
# resource "aws_route_table_association" "association_subnet2" {
#   subnet_id      = aws_subnet.subnet2.id
#   route_table_id = aws_route_table.route_table_subnet2.id
# }



# Agregar regla para apuntar al Internet Gateway
resource "aws_route" "ruta_al_igw1" {
  route_table_id         = aws_route_table.route_table_subnet.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.washington_igw.id
}

# # Agregar regla para apuntar al Internet Gateway
# resource "aws_route" "ruta_al_igw2" {
#   route_table_id         = aws_route_table.route_table_subnet2.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.washington_igw.id
# }
