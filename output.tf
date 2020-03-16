#output ip address
output "instance_ip_addr" {
  value       = aws_eip.webinstance.public_ip
  description = "The public IP address of web server instance."
}

#Public DNS Value
output "public_dns" {
  value       = aws_eip.webinstance.public_dns
  description = "The public DNS of web server instance."
}
