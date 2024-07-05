output "dev_ip" { # to display the public ip of the dev node after 
  value = aws_instance.computing_instance.public_ip
}