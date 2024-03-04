#!/bin/bash
sudo yum update -y && sudo yum install git docker -y sudo service docker start && sudo docker network create web
sudo docker run --restart=unless-stopped --name=postgres -d -p 5432:5432 -e POSTGRES_DB=${var.workspace} -e POSTGRES_USER=${var.workspace} -e POSTGRES_PASSWORD=${var.password} -v /data:/var/lib/postgresql/data postgres
sudo docker stop postgres
sudo echo 'host    replication     dark             ${aws_instance.replica_1.public_ip}/32        md5' >> /home/ec2-user/data/pg_hba.conf
sudo sed -i 's/^#wal_level.*/wal_level = hot_standby/g' /home/ec2-user/data/postgresql.conf
sudo sed -i 's/^#max_wal_senders.*/max_wal_senders = 3/g' /home/ec2-user/data/postgresql.conf
sudo docker start postgres