provider "aws" {
  region      = "${var.region}"
}
resource "aws_instance" "primary_1" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.aws_type}"
  security_groups = ["${aws_security_group.swarm.name}"]
  key_name = "${var.ssh_key}"
  connection {
    host = self.public_ip
    user = "ec2-user"
    #private_key = "${file("${path.module}/id_rsa.pem")}"
    private_key  = "${file("~/.ssh/dark.pem")}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install git -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose;",
      "sudo docker network create web",
      "sudo docker run --restart=unless-stopped --name=postgres -d -p 5432:5432 -e POSTGRES_DB=${var.workspace} -e POSTGRES_USER=${var.workspace} -e POSTGRES_PASSWORD=${var.password} -v $(pwd)/data:/var/lib/postgresql/data postgres",
      "sudo docker run -d --restart=unless-stopped -p 3000:3000 -e PW2_ADHOC_CONN_STR=\"postgresql://${var.workspace}:${var.password}@${self.public_ip}:5432/${var.workspace}\" -e PW2_GRAFANAUSER=admin -e PW2_GRAFANAPASSWORD=admin -e PW2_ADHOC_CONFIG=exhaustive -e PW2_ADHOC_CREATE_HELPERS=true --name pw2 cybertec/pgwatch2-postgres"
    ]
  }
  tags = { 
    Name = "${var.workspace}-primary"
  }
}
#resource "aws_instance" "replica_1" {
#  ami           = "${var.aws_ami}"
#  instance_type = "${var.aws_type}"
#  security_groups = ["${aws_security_group.swarm.name}"]
#  key_name = "${var.ssh_key}"
#  connection {
#    host = self.public_ip
#    user = "ec2-user"
#    #private_key = "${file("${path.module}/id_rsa.pem")}"
#    private_key  = "${file("~/.ssh/dark.pem")}"
#  }
#  provisioner "remote-exec" {
#    inline = [
#      "sudo yum update -y",
#      "sudo yum install git -y",
#      "sudo yum install docker -y",
#      "sudo service docker start",
#      "sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
#      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
#      "sudo chmod +x /usr/local/bin/docker-compose;",
#      "sudo docker network create web",
#      "sudo docker run --restart=unless-stopped --name=postgres -d -p 5432:5432 -e POSTGRES_DB=${var.workspace} -e POSTGRES_USER=${var.workspace} -e POSTGRES_PASSWORD=${var.password} -v $(pwd)/data:/var/lib/postgresql/data postgres",
#      "sudo docker run -d --restart=unless-stopped -p 3000:3000 -e PW2_ADHOC_CONN_STR=\"postgresql://${var.workspace}:${var.password}@${self.public_ip}:5432/${var.workspace}\" -e PW2_GRAFANAUSER=admin -e PW2_GRAFANAPASSWORD=admin -e PW2_ADHOC_CONFIG=exhaustive -e PW2_ADHOC_CREATE_HELPERS=true --name pw2 cybertec/pgwatch2-postgres",
#    ]
#  }
#  tags = { 
#    Name = "${var.workspace}-replica"
#  }
#}