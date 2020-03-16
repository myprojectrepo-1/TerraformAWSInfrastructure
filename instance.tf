# EC2 instance in Public Subnet
resource "aws_instance" "web" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"

  #VPC subnet
  subnet_id = aws_subnet.primary.id

  # Security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-web.id]

  # Tags
  tags = {
    Name = "Web"
  }

  #Keypair
  key_name = aws_key_pair.mykeypair.key_name

  #Upload script.sh file
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  # excecute script.sh file
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}

# Assign Elastic IP to Web Instance 
resource "aws_eip" "webinstance" {
  instance = aws_instance.web.id
  tags = {
    Name = "EIPtoWebInstance"
  }
}

# Create EBS Volume
resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "us-east-1a"
  size              = 2
  type              = "gp2"
  tags = {
    Name = "EBS-ExtraVolume"
  }
}

#Attach EBS Volume to EC2 Instance
resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs-volume-1.id
  instance_id = aws_instance.web.id
}
