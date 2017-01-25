docker rm elasticsearch
docker run -d -m 3g -p 9200:9200 --restart=unless-stopped --name elasticsearch bytewaregmbh/elasticsearch
docker inspect elasticsearch
