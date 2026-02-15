# outputs.tf
output "backend_ip" {
  value = aws_instance.example.public_ip
}
