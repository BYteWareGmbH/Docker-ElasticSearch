docker rm elasticsearch
docker network create -d transparent --subnet=192.168.4.0/24 --gateway=192.168.4.250 dockertrans
docker run -d -m 3g --network=dockertrans --ip 192.168.4.149 --restart=unless-stopped --name elasticsearch bytewaregmbh/elasticsearch
