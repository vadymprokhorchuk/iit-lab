#! /bin/sh

sudo apt-get update
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on

sudo socker pull vadymprokhorchuk/html-server-image
sudo docker pull containrrr/watchtower
sudo docker run -d --name=site -p 80:80 vadymprokhorchuk/html-server-image
sudo docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --interval 10