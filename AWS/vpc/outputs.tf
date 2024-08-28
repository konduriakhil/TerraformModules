output "vpc_info" {
    value = aws_vpc.base
}

output "vpc_id" {
    value = aws_vpc.base.id
}

output "public_subnet_ids" {
    value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
    value = aws_subnet.private.*.id
}
