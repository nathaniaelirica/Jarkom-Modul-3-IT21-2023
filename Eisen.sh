echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get update
apt-get install apache2-utils -y
apt-get install nginx -y
apt-get install lynx -y

service nginx start

echo '
upstream worker {
    least_conn;
    server 10.74.4.6:8001;
    server 10.74.4.5:8002;
    server 10.74.4.4:8003;
}

server {
    listen 80;
    server_name riegel.canyon.it21.com www.riegel.canyon.it21.com;

    location / {
        proxy_pass http://worker;
    }
}
' > /etc/nginx/sites-available/laravel-worker

ln -s /etc/nginx/sites-available/laravel-worker /etc/nginx/sites-enabled/laravel-worker

service nginx restart