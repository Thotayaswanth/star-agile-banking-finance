resource "aws_instance" "test-server" {
  ami = "ami-0360c520857e3138f"
  instance_type = "t2.micro"
  key_name = "ubuntu"
  vpc_security_group_ids = ["sg-08f7cf15cc8f38eea"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./ubuntu.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/finance-project/terraform-files/ansibleplaybook.yml"
     }
  }
