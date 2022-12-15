#!/bin/bash
#this is non persistent configuration. After reboot containers will not start.
#You will need to use command alike "sudo docker start <name of contianer".
#ex. sudo docker start web1

echo "Get actual working directory where docker volumes will be installed"
docDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $docDIR



echo "Stopping old docker images"
docker stop LB web1 web2 web3
echo "removing old nginx-basic directory"
rm -rf $docDIR/nginx-basic
echo "done"
echo ""
echo ""
echo ""
echo "#Setup Reverse Proxy and Load Balancer"
echo ""
echo ""
echo ""

mkdir $docDIR/nginx-basic
mkdir $docDIR/nginx-basic/ReverseLB
echo "upstream apkaLB {
     server 172.17.0.1:8001;
     server 172.17.0.1:8002;
     server 172.17.0.1:8003;
}

server {
      listen 80;
      server_name example.com;
      location / {
      proxy_pass http://apkaLB;
    }
}" > $docDIR/nginx-basic/ReverseLB/nginx.conf
chmod 777 $docDIR/nginx-basic/ReverseLB/nginx.conf
echo ""
echo ""
echo ""
echo "Setting up simple web servers"
echo ""
echo ""
echo ""
mkdir $docDIR/nginx-basic/site1
echo "<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Docker Nginx</title>
</head>
<body>
  <h2>Hello from Nginx container SITE 1</h2>
</body>
</html>" > $docDIR/nginx-basic/site1/index.html



mkdir $docDIR/nginx-basic/site2
echo "<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Docker Nginx</title>
</head>
<body>
  <h2>Hello from Nginx container SITE 2</h2>
</body>
</html>" > $docDIR/nginx-basic/site2/index.html


mkdir $docDIR/nginx-basic/site3
echo "<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Docker Nginx</title>
</head>
<body>
  <h2>Hello from Nginx container SITE 3</h2>
</body>
</html>" > $docDIR/nginx-basic/site3/index.html

echo ""
echo ""
echo ""
#Run webservers
echo ""
echo ""
echo ""
echo "web1"
docker run -it --rm -d -p 8001:80 --name web1 -v $docDIR/nginx-basic/site1:/usr/share/nginx/html nginx
echo "web2"
docker run -it --rm -d -p 8002:80 --name web2 -v $docDIR/nginx-basic/site2:/usr/share/nginx/html nginx
echo "web3"
docker run -it --rm -d -p 8003:80 --name web3 -v $docDIR/nginx-basic/site3:/usr/share/nginx/html nginx

echo ""
echo ""
echo ""
echo "Run LB"
echo ""
echo ""
echo ""
docker run -it --rm -d -p 8080:80 --name LB -v $docDIR/nginx-basic/ReverseLB:/etc/nginx/conf.d/ nginx
