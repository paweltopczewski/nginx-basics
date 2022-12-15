#!/bin/bash
echo ""
echo ""
echo ""
echo "#Setup Reverse Proxy and Load Balancer"
echo ""
echo ""
echo ""

sudo mkdir ~/nginx-basic/ 
sudo mkdir ~/nginx-basic/ReverseLB 
echo "upstream apkaLB { \
     server 172.17.0.1:8001; \
     server 172.17.0.1:8002 weight=3; \
     server 172.17.0.1:8003; \
} \
\
server { \
      listen 80; \
      server_name example.com; \
      location / { \
      proxy_pass http://apkaLB; \
    } \
}" > ~/nginx-basic/ReverseLB/nginx.com
sudo chmod 777 ~/nginx-basic/ReverseLB/nginx.com
echo ""
echo ""
echo ""
echo "Setting up simple web servers"
echo ""
echo ""
echo ""
sudo mkdir ~/nginx-basic/site1
echo "<!doctype html> \
<html lang="en"> \
<head> \
  <meta charset="utf-8"> \
  <title>Docker Nginx</title> \
</head> \
<body> \
  <h2>Hello from Nginx container SITE 1</h2> \
</body> \
</html>" > ~/nginx-basic/site1/index.html



sudo mkdir ~/nginx-basic/site2
echo "<!doctype html> \
<html lang="en"> \
<head> \
  <meta charset="utf-8"> \
  <title>Docker Nginx</title> \
</head> \
<body> \
  <h2>Hello from Nginx container SITE 2</h2> \
</body> \
</html>" > ~/nginx-basic/site2/index.html


sudo mkdir ~/nginx-basic/site3
echo "<!doctype html> \
<html lang="en"> \
<head> \
  <meta charset="utf-8"> \
  <title>Docker Nginx</title> \
</head> \
<body> \
  <h2>Hello from Nginx container SITE 3</h2> \
</body> \
</html>" > ~/nginx-basic/site3/index.html

echo ""
echo ""
echo ""
#Run webservers
echo ""
echo ""
echo ""
sudo docker run -it --rm -d -p 8001:80 --name web1 -v ~/nginx-basic/site1:/usr/share/nginx/html nginx
sudo docker run -it --rm -d -p 8002:80 --name web2 -v ~/nginx-basic/site2:/usr/share/nginx/html nginx
sudo docker run -it --rm -d -p 8003:80 --name web3 -v ~/nginx-basic/site3:/usr/share/nginx/html nginx

echo ""
echo ""
echo ""
echo "Run LB"
echo ""
echo ""
echo ""
