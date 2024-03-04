provider "aws" {
  region      = "${var.region}"
}
resource "aws_instance" "primary_1" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.aws_type}"
  security_groups = ["${aws_security_group.swarm.name}"]
  key_name = "${var.ssh_key}"
  user_data = <<EOF
#!/bin/bash
sudo yum update -y && sudo yum install git docker -y && sudo service docker start && sudo docker network create web
sudo docker run --restart=unless-stopped --name=postgres -d -p 5432:5432 -e POSTGRES_DB=${var.workspace} -e POSTGRES_USER=${var.workspace} -e POSTGRES_PASSWORD=${var.password} -v /data:/var/lib/postgresql/data postgres
sudo docker stop postgres
ip="$(curl ifconfig.me)"
echo $t >/tmp/ip
sudo echo "host    replication     dark  $ip/32        md5" >> /data/pg_hba.conf
sudo sed -i 's/^#wal_level.*/wal_level = replica/g' /data/postgresql.conf
sudo sed -i 's/^#max_wal_senders.*/max_wal_senders = 10/g' /data/postgresql.conf
sudo sed -i 's/^#wal_keep_segments.*/wal_keep_segments = 64/g' /data/postgresql.conf
sudo docker start postgres
  EOF
  tags = { 
    Name = "postgresql-primary"
  }
}
resource "aws_instance" "replica_1" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.aws_type}"
  security_groups = ["${aws_security_group.swarm.name}"]
  key_name = "${var.ssh_key}"
  user_data = <<EOF
#!/bin/bash
sudo yum update -y && sudo yum install git docker -y && sudo service docker start && sudo docker network create web
sudo docker run --restart=unless-stopped --name=postgres -d -p 5432:5432 -e POSTGRES_DB=${var.workspace} -e POSTGRES_USER=${var.workspace} -e POSTGRES_PASSWORD=${var.password} -v /data:/var/lib/postgresql/data postgres
sudo docker stop postgres
ip="$(curl ifconfig.me)"
sudo echo "host    replication     dark             $ip/32        md5" >> /data/pg_hba.conf
sudo sed -i 's/^#wal_level.*/wal_level = replica/g' /data/postgresql.conf
sudo sed -i 's/^#max_wal_senders.*/max_wal_senders = 10/g' /data/postgresql.conf
sudo sed -i 's/^#wal_keep_segments.*/wal_keep_segments = 64/g' /data/postgresql.conf
sudo sed -i 's/^#hot_standby.*/hot_standby = on/g' /data/postgresql.conf
sudo docker start postgres
  EOF
  tags = { 
    Name = "postgresql-replica"
  }
}