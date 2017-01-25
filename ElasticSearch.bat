docker rm elasticsearch
docker run -d -m 3g --restart=unless-stopped --name elasticsearch bytewaregmbh/elasticsearch
docker inspect elasticsearch
