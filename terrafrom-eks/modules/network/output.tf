output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
value = aws_subnet.public.id
}

output "public1_subnet_id" {
value = aws_subnet.public1.id
}

output "private_subnet_id" {
value = aws_subnet.private.id
}

output "private1_subnet_id" {
value = aws_subnet.private.id
}

output "security_group_id" {
value = aws_security_group.instance.id
}
