
resource "aws_instance" "Jenkins" {
  ami           = "ami-007855ac798b5175e"  # Ubuntu 20.04 LTS
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.forassignment_subnet_1.id
  key_name      = "ec2-key"
  associate_public_ip_address = true

  tags = {
    Name = "Jenkins Master"
  }
    security_groups = [aws_security_group.forassignment_sg.id]

    connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./ec2-key.pem")
    host = aws_instance.Jenkins.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y gnupg",
      "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5BA31D57EF5975CA",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt-get update -y",
      "sudo apt-get install -y openjdk-11-jdk",
      "sudo apt-get install -y wget",
      "sudo apt-get install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins",
    ]
  }
}

resource "aws_instance" "k8s-1" {
  ami           = "ami-007855ac798b5175e"  # Ubuntu 20.04 LTS
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.forassignment_subnet_2.id
  key_name      = "ec2-key"
  associate_public_ip_address = true

  tags = {
    Name = "k8s-1"
  }
    security_groups = [aws_security_group.forassignment_sg.id]

    connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./ec2-key.pem")
    host = aws_instance.k8s-1.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y openjdk-8-jdk",      
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo apt-get install -y apt-transport-https ca-certificates curl",
      "sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update -y",
      "sudo swapoff -a",
      "sudo apt-get install kubelet=1.20.0-00 kubeadm=1.20.0-00 kubectl=1.20.0-00 -y",
      "sudo apt-get update -y",
    ]
  }
}

resource "aws_instance" "k8s-2" {
  ami           = "ami-007855ac798b5175e"  # Ubuntu 20.04 LTS
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.forassignment_subnet_2.id
  key_name      = "ec2-key"
  associate_public_ip_address = true

  tags = {
    Name = "k8s-2"
  }
    security_groups = [aws_security_group.forassignment_sg.id]

    connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./ec2-key.pem")
    host = aws_instance.k8s-2.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y openjdk-8-jdk",      
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo apt-get install -y apt-transport-https ca-certificates curl",
      "sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update -y",
      "sudo swapoff -a",
      "sudo apt-get install kubelet=1.20.0-00 kubeadm=1.20.0-00 kubectl=1.20.0-00 -y",
      "sudo apt-get update -y",
    ]
  }
}
