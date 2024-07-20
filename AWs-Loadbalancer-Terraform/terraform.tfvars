region = "us-east-2"
key_name = "ec2-instance"

vpc_name = "ec2-vpc"
vpc_cidr = "192.168.21.0/24"
internet_gw_name = "ec2-gw"
subnet1 ={
    name = "ec2-subnet1"
    cidr_block = "192.168.21.0/25"
    availability_zone = "us-east-2a"

}

# eip = "ec2-eip"
# nat_gw_name = "ec2-nat"
rt1_name = "ec2_public_subnet_route_table"
ec2_name = [ "server1","server2" ]