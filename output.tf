output "public_ip" {
  value = [
    for instance in aws_instance.aws_new : instance.public_ip
  ]

}