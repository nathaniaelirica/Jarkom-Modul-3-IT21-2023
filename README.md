# Praktikum Modul 3 Jarkom 2023
| Nama                           | NRP      |
|--------------------------------|-------------|
| Maria Teresia Elvara Bumbungan | 5027211042  |
| Nathania Elirica Aliyah        | 5027211057  |

## Network Configuration
Lakukan konfigurasi sesuai dengan peta yang sudah diberikan.

![topologi](https://i.ibb.co/Kq9KRJp/topologi.png)

Berikut merupakan konfigurasi untuk tiap node:
- Aura
```sh
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 10.74.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.74.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 10.74.3.1
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 10.74.4.1
	netmask 255.255.255.0
```
- Himmel
```sh
auto eth0
iface eth0 inet static
	address 10.74.1.2
	netmask 255.255.255.0
	gateway 10.74.1.1
```
- Heiter
```sh
auto eth0
iface eth0 inet static
	address 10.74.1.3
	netmask 255.255.255.0
	gateway 10.74.1.1
```
- Denken
```sh
auto eth0
iface eth0 inet static
	address 10.74.2.2
	netmask 255.255.255.0
	gateway 10.74.2.1
```
- Eisen
```sh
auto eth0
iface eth0 inet static
	address 10.74.2.3
	netmask 255.255.255.0
	gateway 10.74.2.1
```
- Frieren
```sh
auto eth0
iface eth0 inet static
	address 10.74.4.4
	netmask 255.255.255.0
	gateway 10.74.4.1
```
- Flamme
```sh
auto eth0
iface eth0 inet static
	address 10.74.4.5
	netmask 255.255.255.0
	gateway 10.74.4.1
```
- Fern
```sh
auto eth0
iface eth0 inet static
	address 10.74.4.6
	netmask 255.255.255.0
	gateway 10.74.4.1
```
- Lawine
```sh
auto eth0
iface eth0 inet static
	address 10.74.3.4
	netmask 255.255.255.0
	gateway 10.74.3.1
```
- Linie
```sh
auto eth0
iface eth0 inet static
	address 10.74.3.5
	netmask 255.255.255.0
	gateway 10.74.3.1
```
- Lugner
```sh
auto eth0
iface eth0 inet static
	address 10.74.3.6
	netmask 255.255.255.0
	gateway 10.74.3.1
```
- Revolte, Richter, Sein, Stark
```sh
auto eth0
iface eth0 inet dhcp
```

## Soal 0
Setelah mengalahkan Demon King, perjalanan berlanjut. Kali ini, kalian diminta untuk melakukan register domain berupa riegel.canyon.yyy.com untuk worker Laravel dan granz.channel.yyy.com untuk worker PHP (0) mengarah pada worker yang memiliki IP [prefix IP].x.1.

Untuk mengerjakan soal ini, perlu dilakukan instalasi bind9 pada DNS Server yaitu Heiter. Setelah itu, dilakukan konfigurasi untuk melakukan register kedua domain sesuai soal. Seluruh langkah disimpan di `.bashrc`.

```sh
apt-get update
apt-get install bind9 -y

echo "
zone \"riegel.canyon.it21.com\" {
    type master;
    file \"/etc/bind/jarkom/riegel.canyon.it21.com\";
};

zone \"granz.channel.it21.com\" {
    type master;
    file \"/etc/bind/jarkom/granz.channel.it21.com\";
};
" > /etc/bind/named.conf.local

mkdir /etc/bind/jarkom
cp /etc/bind/db.local /etc/bind/jarkom/riegel.canyon.it21.com

echo "
\$TTL    604800
@       IN      SOA     riegel.canyon.it21.com. root.canyon.it21.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      riegel.canyon.it21.com.
@       IN      A       10.74.4.6
www     IN      CNAME   riegel.canyon.it21.com.
" > /etc/bind/jarkom/riegel.canyon.it21.com

cp /etc/bind/db.local /etc/bind/jarkom/granz.channel.it21.com

echo "
\$TTL    604800
@       IN      SOA     granz.channel.it21.com. root.granz.channel.it21.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      granz.channel.it21.com.
@       IN      A       10.74.3.2
www     IN      CNAME   granz.channel.it21.com.
" > /etc/bind/jarkom/granz.channel.it21.com

service bind9 restart
```
Selanjutnya, dilakukan testing dengan melakukan ping terhadap kedua domain di client. Sebagai contoh, testing dilakukan di Revolte.

![soal 5](https://i.ibb.co/DkKVJ6j/image.png)

## Soal 2
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.16 - [prefix IP].3.32 dan [prefix IP].3.64 - [prefix IP].3.80

Untuk menyelesaikan soal ini, perlu dilakukan konfigurasi di DHCP Relay terlebih dahulu yaitu, Aura. Berikut merupakan langkah instalasi dan konfigurasinya:
```sh
apt-get update
apt-get install isc-dhcp-relay -y
service isc-dhcp-relay start

echo "
# Defaults for isc-dhcp-relay initscript
# sourced by /etc/init.d/isc-dhcp-relay
# installed at /etc/default/isc-dhcp-relay by the maintainer scripts

#
# This is a POSIX shell fragment
#

# What servers should the DHCP relay forward requests to?
SERVERS=\"10.74.1.2\"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES=\"eth1 eth2 eth3 eth4\"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=\"\" 
" > /etc/default/isc-dhcp-relay

echo "
net.ipv4.ip_forward=1
" > /etc/sysctl.conf

service isc-dhcp-relay restart
```

Setelah itu, perlu dilakukan konfigurasi di DHCP Server yaitu Himmel untuk menetapkan range IP sesuai dengan permintaan soal. Berikut merupakan langkah instalasi dan konfigurasinya:
```sh
apt-get update
apt-get install isc-dhcp-server -y

echo "
# Defaults for isc-dhcp-server (sourced by /etc/init.d/isc-dhcp-server)

# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf

# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
#DHCPDv4_PID=/var/run/dhcpd.pid
#DHCPDv6_PID=/var/run/dhcpd6.pid

# Additional options to start dhcpd with.
#       Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4=\"eth0\"
INTERFACESv6=\"\"
" > /etc/default/isc-dhcp-server

echo "
subnet 10.74.1.0 netmask 255.255.255.0 {}

subnet 10.74.2.0 netmask 255.255.255.0 {}

subnet 10.74.3.0 netmask 255.255.255.0 {
    range 10.74.3.16 10.74.3.32;
    range 10.74.3.64 10.74.3.80;
    option routers 10.74.3.1;
} 
" > /etc/dhcp/dhcpd.conf
```

## Soal 3
Client yang melalui Switch4 mendapatkan range IP dari [prefix IP].4.12 - [prefix IP].4.20 dan [prefix IP].4.160 - [prefix IP].4.168

Seperti soal sebelumnya, perlu ditambahkan konfigurasi pada Himmel untuk menetapkan range IP. Berikut merupakan konfigurasinya:
```sh
echo "
subnet 10.74.1.0 netmask 255.255.255.0 {}

subnet 10.74.2.0 netmask 255.255.255.0 {}

subnet 10.74.3.0 netmask 255.255.255.0 {
    range 10.74.3.16 10.74.3.32;
    range 10.74.3.64 10.74.3.80;
    option routers 10.74.3.1;
}

subnet 10.74.4.0 netmask 255.255.255.0 {
    range 10.74.4.12 10.74.4.20;
    range 10.74.4.160 10.74.4.168;
    option routers 10.74.4.1;
}
" > /etc/dhcp/dhcpd.conf
```

## Soal 4
Client mendapatkan DNS dari Heiter dan dapat terhubung dengan internet melalui DNS tersebut.

Untuk menyelesaikan soal ini, perlu ditambahkan konfigurasi `option domain-name-servers` yang diarahkan ke IP Heiter. Berikut konfigurasinya:
```sh
echo "
subnet 10.74.1.0 netmask 255.255.255.0 {}

subnet 10.74.2.0 netmask 255.255.255.0 {}

subnet 10.74.3.0 netmask 255.255.255.0 {
    range 10.74.3.16 10.74.3.32;
    range 10.74.3.64 10.74.3.80;
    option routers 10.74.3.1;
    option domain-name-servers 10.74.1.3;
}

subnet 10.74.4.0 netmask 255.255.255.0 {
    range 10.74.4.12 10.74.4.20;
    range 10.74.4.160 10.74.4.168;
    option routers 10.74.4.1;
    option domain-name-servers 10.74.1.3;
}
" > /etc/dhcp/dhcpd.conf
```

Selanjutnya, pada DNS Heiter juga ditambahkan konfigurasi seperti berikut:
```sh
echo '
options {
      directory "/var/cache/bind";

      forwarders {
              192.168.122.1;
      };

      // dnssec-validation auto;
      allow-query{any;};
      auth-nxdomain no;    # conform to RFC1035
      listen-on-v6 { any; };
};
' >/etc/bind/named.conf.options

service bind9 restart
```

Setelah itu, dilakukan testing di client dengan melakukan `ping google.com`. Berikut merupakan hasilnya:

![soal 4](https://i.ibb.co/Z67V1qh/soal5.png)

Dapat dilihat bahwa client telah berhasil terhubung ke internet melalui DNS Heiter dikarenakan saat menjalankan `cat /etc/resolv.conf`, tertera IP DNS Heiter dan berhasil melakukan ping terhadap Google.

## Soal 5
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch3 selama 3 menit sedangkan pada client yang melalui Switch4 selama 12 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 96 menit.

Untuk menyelesaikan soal ini, perlu ditambahkan konfigurasi `default-lease-time` dan `max-lease-time` sesuai dengan soal. Berikut merupakan konfigurasinya:
```sh
echo "
subnet 10.74.1.0 netmask 255.255.255.0 {}

subnet 10.74.2.0 netmask 255.255.255.0 {}

subnet 10.74.3.0 netmask 255.255.255.0 {
    range 10.74.3.16 10.74.3.32;
    range 10.74.3.64 10.74.3.80;
    option routers 10.74.3.1;
    option domain-name-servers 10.74.1.3;
    default-lease-time 180;
    max-lease-time 5760;
}

subnet 10.74.4.0 netmask 255.255.255.0 {
    range 10.74.4.12 10.74.4.20;
    range 10.74.4.160 10.74.4.168;
    option routers 10.74.4.1;
    option domain-name-servers 10.74.1.3;
    default-lease-time 720;
    max-lease-time 5760;
}
" > /etc/dhcp/dhcpd.conf
```
Setelah itu, dilakukan testing pada client apakah sudah sesuai dengan ketentuan kelima soal tadi dengan melihat informasi lease time dan melakukan ping kepada kedua domain. Sebelum melakukan testing, node client perlu dimatikan terlebih dahulu. Berikut hasilnya:

**Revolte**

![soal 5](https://i.ibb.co/3NSbntm/soal5-r.jpg)

**Stark**

![soal 5](https://i.ibb.co/fdjfrq4/soal5-s.jpg)

Dapat dilihat bahwa konfigurasi DHCP telah berhasil. Hal ini dapat dilihat dari range IP dan lease time client Revolte dan Stark yang sudah sesuai dengan konfigurasi yang telah di-set.

## Soal 6
Pada masing-masing worker PHP, lakukan konfigurasi virtual host untuk website berikut dengan menggunakan php 7.3.

**Analisis**

Untuk menyelesaikan soal ini, perlu melakukukan download dan unzip lalu mengkofigurasikannya di tiap *php worker* Berikut merupakan konfigurasinya:


**Bashrc**
```
echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get update
apt-get install nginx -y
apt-get install lynx -y
apt-get install php php-fpm -y
apt-get install wget -y
apt install htop -y
apt install apache2-utils -y
apt-get install jq -y
apt-get install unzip -y
service nginx start
service php7.3-fpm start

wget -O '/var/www/granz.channel.it21.com' 'https://drive.google.com/u/0/uc?id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1&export=down$unzip -o /var/www/granz.channel.it21.com -d /var/www/
rm /var/www/granz.channel.it21.com
mv /var/www/modul-3 /var/www/granz.channel.it21.com
```
**Script.sh**
```
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/granz.channel.it21.com
ln -s /etc/nginx/sites-available/granz.channel.it21.com /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

echo 'server {
    listen 80;
    server_name _;

    root /var/www/granz.channel.it21.com;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}' > /etc/nginx/sites-available/granz.channel.it21.com

service nginx restart
```
Berikut hasilnya:

```lynx localhost```

![soal 6](https://i.ibb.co/7Y8W116/image.png)

Dapat dilihat bahwa  konfigurasi virtual host untuk website telah berhasil. Hal ini dapat dilihat dari ouput saat website diakses yang sudah sesuai dengan konfigurasi yang telah di-set.

## Soal 7
Kepala suku dari Bredt Region memberikan resource server sebagai berikut:

Lawine, 4GB, 2vCPU, dan 80 GB SSD.

Linie, 2GB, 2vCPU, dan 50 GB SSD.

Lugner 1GB, 1vCPU, dan 25 GB SSD.

aturlah agar Eisen dapat bekerja dengan maksimal, lalu lakukan testing dengan 1000 request dan 100 request/second.

**Analisis**

Untuk menyelesaikan soal ini, arahkan ip domain terlebih dahulu. Berikut merupakan konfigurasinya:


**Heiter**
```
\$TTL    604800
@       IN      SOA     reigel.canyon.it21.com. root.riegel.canyon.it21.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      reigel.canyon.it21.com.
@       IN      A       10.74.2.3
" > /etc/bind/jarkom/riegel.canyon.it21.com


cp /etc/bind/db.local /etc/bind/jarkom/granz.channel.it21.com.

echo "
\$TTL    604800
@       IN      SOA     granz.channel.it21.com. root.granz.channel.it21.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      granz.channel.it21.com.
@       IN      A       10.74.2.3
" > /etc/bind/jarkom/granz.channel.it21.com
```
**Eisen**
```
apt-get update
apt-get install nginx -y
apt-get install lynx -y
apt-get install htop -y

apt-get install apache2-utils -y

service nginx start
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/lb_php

mkdir /etc/nginx/rahasisakita

echo ' upstream worker {
    server 10.74.3.4;
    server 10.74.3.5;
    server 10.74.3.6;
}

server {
    listen 80;
    server_name granz.channel.it21.com www.granz.channel.it21.com;

    root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
   
       proxy_pass http://worker;

    }

} ' > /etc/nginx/sites-available/lb_php

ln -s /etc/nginx/sites-available/lb_php /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

service nginx restart
```
Berikut hasilnya:

```ab -n 1000 -c 100 http://granz.channel.it21.com/ ```

![soal 7](https://i.ibb.co/F7T4L0C/image.png)

![soal 7](https://i.ibb.co/ygJwSSK/image.png)

Dapat dilihat bahwa  testing dengan 1000 request dan 100 request/second telah berhasil. 

## Soal 8
Karena diminta untuk menuliskan grimoire, buatlah analisis hasil testing dengan 200 request dan 10 request/second masing-masing algoritma Load Balancer 

**Analisis**

Untuk menyelesaikan soal ini, tambahkan pada pada file /etc/nginx/sites-available/lb_php pada eisen sesuai dengan algoritma yang ditentukan yaitu

**Round Robin**
```
echo ' upstream worker {
    server 10.74.3.4;
    server 10.74.3.5;
    server 10.74.3.6;
}
```
**IP Hash**
```
echo ' upstream worker {
    ip_hash;
    server 10.74.3.4;
    server 10.74.3.5;
    server 10.74.3.6;
}
```
**Least Connection**
```
echo ' upstream worker {
    least_conn;
    server 10.74.3.4;
    server 10.74.3.5;
    server 10.74.3.6;
}
```
**Generic Hash**
```
echo ' upstream worker {
    hash $request_uri consistent;
    server 10.74.3.4;
    server 10.74.3.5;
    server 10.74.3.6;
}
```
Berikut Hasilnya :

**Round Robin**

![soal 10](https://i.ibb.co/7G62w6Z/image.png)

**IP Hash**

![soal 10](https://i.ibb.co/5sMnCr6/image.png)

**Least Connection**

![soal 10](https://i.ibb.co/85N8P09/image.png)

**Generic Hash**

![soal 10](https://i.ibb.co/swNrjcz/image.png)


![soal 10](https://i.ibb.co/M25M5dd/image.png)

## Soal 9
Dengan menggunakan algoritma Round Robin, lakukan testing dengan menggunakan 3 worker, 2 worker, dan 1 worker sebanyak 100 request dengan 10 request/second, kemudian tambahkan grafiknya pada grimoire.

**Analisis**

Pada file /etc/nginx/sites-available/lb_php di eisen mencoba menggunakan ```1 worker```, ```2 worker```, dan ```3 worker```

Berikut hasilnya : 


**1 worker**

![soal 10](https://i.ibb.co/nc53pwM/image.png)

**2 worker**

![soal 10](https://i.ibb.co/hRvB8s3/image.png)

**3 worker**

![soal 10](https://i.ibb.co/fvTkK0d/image.png)

![soal 10](https://i.ibb.co/sCc9Bgw/image.png)


## Soal 10
Selanjutnya coba tambahkan konfigurasi autentikasi di LB dengan dengan kombinasi username: “netics” dan password: “ajkyyy”, dengan yyy merupakan kode kelompok. Terakhir simpan file “htpasswd” nya di /etc/nginx/rahasisakita/

**Analisis**

Untuk menyelesaikan soal ini, buatlah folder dan set up password.Berikut merupakan konfigurasinya:


**Eisen**
```
mkdir /etc/nginx/rahasisakita
htpasswd -c /etc/nginx/rahasisakita/htpasswd netics
```
Tambahkan code ini pada location di file /etc/nginx/sites-available/lb_php
```
auth_basic "Restricted Content";
auth_basic_user_file /etc/nginx/rahasisakita/htpasswd;
```
Lalu run dan masukkan password ```ajkit21```

Berikut hasilnya:

```lynx http://granz.channel.it21.com/ ```

![soal 10](https://i.ibb.co/hR5hsp3/image.png)

![soal 10](https://i.ibb.co/y55BpsP/image.png)

![soal 10](https://i.ibb.co/pbVVz1n/image.png)

![soal 10](https://i.ibb.co/6yLFcDk/image.png)

## Soal 11
Lalu buat untuk setiap request yang mengandung /its akan di proxy passing menuju halaman https://www.its.ac.id. (11) hint: (proxy_pass)

**Analisis**

Untuk menyelesaikan soal ini, tambahkan konfigurasi password dan buat folder, berikut merupakan konfigurasi tambahannya :

**Eisen**

/etc/nginx/sites-available/lb_php
```
location ~ /its {
    proxy_pass https://www.its.ac.id;
    proxy_set_header Host www.its.ac.id;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```
Berikut hasilnya :

```lynx http://granz.channel.it21.com/its ```

![soal 12](https://i.ibb.co/9GPSQmD/image.png)


## Soal 12
Selanjutnya LB ini hanya boleh diakses oleh client dengan IP [Prefix IP].3.69, [Prefix IP].3.70, [Prefix IP].4.167, dan [Prefix IP].4.168.

**Analisis**

Untuk menyelesaikan soal ini, tambahkan konfigurasi ip  .Berikut merupakan konfigurasi tambahannya:


**Eisen**

Tambahkan di location pada file /etc/nginx/sites-available/lb_php
```
    allow 10.74.3.69;
    allow 10.74.3.70;
    allow 10.74.4.167;
    allow 10.74.4.168;
```
**Himmel**

Tambahkan konfigurasi pada file /etc/dhcp/dhcpd.conf

```
host Revolte {
 hardware ethernet 82:b0:a9:88:c9:82;
 fixed-address 10.74.3.69;
}
```
**Client**

Tambahkan konfigurasi pada /etc/network/interfaces
```
hwaddress ether 10.74.3.69
```

Berikut hasilnya:

**deny**

![soal 12](https://i.ibb.co/SxQyQqd/image.png)

**allow**

![soal 12](https://i.ibb.co/6yLFcDk/image.png)

![soal 12](https://i.ibb.co/xFxqJLQ/image.png)

## Soal 13
Semua data yang diperlukan, diatur pada Denken dan harus dapat diakses oleh Frieren, Flamme, dan Fern.

Untuk menyelesaikan soal ini, perlu dilakukan instalasi mysql dan konfigurasi di Database Server yaitu, Denken. Berikut langkah-langkahnya:
```sh
apt-get update
apt-get install mariadb-server -y
service mysql start

echo "
[mysqld]
skip-networking=0
skip-bind-address
" > /etc/mysql/my.cnf

service mysql restart
```

Selanjutnya, jalankan command-command berikut:
```sh
mysql -u root -p

CREATE USER 'kelompokIT21'@'%' IDENTIFIED BY 'passwordIT21';
CREATE USER 'kelompokIT21'@'localhost' IDENTIFIED BY 'passwordIT21';
CREATE DATABASE dbkelompokIT21;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokIT21'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokIT21'@'localhost';
FLUSH PRIVILEGES;
```

Setelah itu, lakukan testing pada salah satu Laravel Worker. Pada Laravel Worker perlu dilakukan instalasi terlebih dahulu sebagai berikut:
```sh
apt-get update
apt-get install mariadb-client -y
```

Selanjutnya, untuk mengecek apakah database dapat diakses oleh seluruh worker dengan menjalankan command berikut di salah satu Laravel Worker:
```sh
mariadb --host=10.74.2.2 --port=3306 --user=kelompokIT21 --password

SHOW DATABASES;
```

Berikut merupakan hasilnya:

![soal 13](https://i.ibb.co/2YsW8ww/soal13.jpg)

Dapat dilihat bahwa Fern telah berhasil mengakses database sesuai dengan ketentuan soal.

## Soal 14
Frieren, Flamme, dan Fern memiliki Riegel Channel sesuai dengan quest guide berikut. Jangan lupa melakukan instalasi PHP8.0 dan Composer.

Untuk menyelesaikan soal ini, perlu melakukan beberapa instalasi pada Laravel Worker. Berikut langkah instalasinya:
```sh
apt-get update

apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

apt-get install php8.0-mbstring php8.0-xml php8.0-cli php8.0-common php8.0-intl php8.0-opcache php8.0-readline php8.0-mysql php8.0-fpm php8.0-curl unzip wget -y

apt-get install nginx -y
apt-get install lynx -y
apt-get install apache2-utils -y

apt-get install wget -y
wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer

apt-get install git -y
```

Selanjutnya, perlu melakukan `git clone` resource yang telah diberikan
```sh
cd /var/www && git clone https://github.com/martuafernando/laravel-praktikum-jarkom.git
cd /var/www/laravel-praktikum-jarkom && composer update
```

Selanjutnya, perlu melakukan beberapa konfigurasi pada tiap worker sebagai berikut:
```sh
cd /var/www/laravel-praktikum-jarkom && cp .env.example .env
echo '
APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:z70nhApUrqTL6RdG3HQku6UPwC/JtMOvBN3N0fOvVAc=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=10.74.2.2
DB_PORT=3306
DB_DATABASE=dbkelompokIT21
DB_USERNAME=kelompokIT21
DB_PASSWORD=passwordIT21

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
' > /var/www/laravel-praktikum-jarkom/.env
cd /var/www/laravel-praktikum-jarkom && php artisan migrate:fresh
cd /var/www/laravel-praktikum-jarkom && php artisan db:seed --class=AiringsTableSeeder
cd /var/www/laravel-praktikum-jarkom && php artisan key:generate
cd /var/www/laravel-praktikum-jarkom && php artisan jwt:secret
cd /var/www/laravel-praktikum-jarkom && php artisan storage:link
chown -R www-data.www-data /var/www/laravel-praktikum-jarkom/storage
```

Selanjutnya, perlu melakukan konfigurasi nginx pada tiap worker. Berikut penetapan port untuk tiap worker:
```sh
# Fern
10.74.4.6:8001
# Flamme
10.74.4.5:8002
### Frieren
10.74.4.4:8003
```
Berikut merupakan konfigurasi nginx pada salah satu worker yaitu, Fern:
```sh
echo '
server {
    listen 8001;

    root /var/www/laravel-praktikum-jarkom/public;

    index index.php index.html index.htm;
    server_name _;

    location / {
            try_files $uri $uri/ /index.php?$query_string;
    }

    # pass PHP scripts to FastCGI server
    location ~ \.php$ {
      include snippets/fastcgi-php.conf;
      fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
    }

    location ~ /\.ht {
            deny all;
    }

    error_log /var/log/nginx/praktikum-jarkom_error.log;
    access_log /var/log/nginx/praktikum-jarkom_access.log;
}
' > /etc/nginx/sites-available/praktikum-jarkom

ln -s /etc/nginx/sites-available/praktikum-jarkom /etc/nginx/sites-enabled/laravel-worker

service nginx restart
```

Selanjutnya, dilakukan testing pada masing-masing worker dengan command berikut:
```sh
lynx localhost:[port]
```
Berikut hasilnya di salah satu worker Fern dengan port 8001:

![soal 14](https://i.ibb.co/tQs49M4/soal14.jpg)

## Soal 15
Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second. Lakukan testing pada endpoint POST /auth/register.

Untuk menyelesaikan soal ini, dilakukan testing menggunakan Apache Benchmark terhadap salah satu worker dan dilakukan di salah satu client. Sebagai contoh, testing akan dilakukan terhadap worker Fern di client Revolte. 

Untuk melakukan testing, perlu melakukan instalasi dan membuat file body yang akan dikirimkan ke endpoint di client terlebih dahulu. Berikut tahapannya:
```sh
apt-get update
apt-get install lynx -y
apt-get install htop -y
apt-get install apache2-utils -y
apt-get install jq -y

echo '
{
  "username": "kelompokIT21",
  "password": "passwordIT21"
}' > register.json
```

Selanjutnya, jalankan command berikut untuk melakukan testing di client:
```sh
ab -n 100 -c 10 -p register.json -T application/json http://10.74.4.6:8001/api/auth/register
```
Berikut merupakan hasilnya:

![soal 15](https://i.ibb.co/VYCPqZL/soal15.png)

Dapat dilihat bahwa dari 100 request yang dikirim, terdapat **1 request yang berhasil diproses** dan **99 request yang gagal diproses.** Hal ini wajar dikarenakan proses registrasi menggunakan akun yang sama hanya bisa dilakukan satu kali.

## Soal 16
Lakukan testing pada endpoint POST /auth/register

Seperti soal sebelumnya, perlu membuat file body terlebih dahulu sebagai berikut:
```sh
echo '
{
  "username": "kelompokIT21",
  "password": "passwordIT21"
}' > login.json
```

Selanjutnya, jalankan command berikut untuk melakukan testing di client:
```sh
ab -n 100 -c 10 -p login.json -T application/json http://10.74.4.6:8001/api/auth/login
```

Berikut merupakan hasilnya:

![soal 16](https://i.ibb.co/T1RNFPX/soal16.jpg)

Dapat dilihat bahwa dari 100 request yang dikirim, terdapat **61 request yang berhasil diproses** dan **39 request yang gagal diproses.**

## Soal 17
Lakukan testing pada endpoint GET /me

Untuk menyelesaikan soal ini, perlu mendapatkan token dengan cara berikut:
```sh
curl -X POST -H "Content-Type: application/json" -d @login.json http://10.74.4.6:8001/api/auth/login > login_output.txt

token=$(cat login_output.txt | jq -r '.token')
```

Untuk melihat token, jalankan command berikut
```sh
cat login_output.txt
```
Berikut adalah tokennya:

![soal 17 token](https://i.ibb.co/wrPJgr2/soal17token.jpg)

Selanjutnya, jalankan command berikut untuk melakukan testing di client:
```sh
ab -n 100 -c 10 -H "Authorization: Bearer $token" http://10.74.4.6:8001/api/me
```

Berikut merupakan hasilnya:

![soal 17](https://i.ibb.co/VLz6yV2/soal17.png)

Dapat dilihat bahwa dari 100 request yang dikirim, terdapat **60 request yang berhasil diproses** dan **40 request yang gagal diproses.**

## Soal 18
Untuk memastikan ketiganya bekerja sama secara adil untuk mengatur Riegel Channel maka implementasikan Proxy Bind pada Eisen untuk mengaitkan IP dari Frieren, Flamme, dan Fern.

Untuk menyelesaikan soal ini, perlu dilakukan konfigurasi nginx pada Load Balancer yaitu Eisen. Berikut konfigurasinya:
```sh
echo '
upstream worker {
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
```

Selanjutnya pada DNS Server atau Heiter, perlu dilakukan perubahan sedikit yaitu mengganti IP pada domain server riegel.canyon.it21.com menjadi IP Eisen. Berikut konfigurasinya:
```sh
echo "
\$TTL    604800
@       IN      SOA     riegel.canyon.it21.com. root.canyon.it21.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      riegel.canyon.it21.com.
@       IN      A       10.74.2.3
www     IN      CNAME   riegel.canyon.it21.com.
" > /etc/bind/jarkom/riegel.canyon.it21.com
```

Selanjutnya, dilakukan testing pada salah satu client ke endpoint `/auth/login` dengan command berikut:
```sh
ab -n 100 -c 10 -p login.json -T application/json http://www.riegel.canyon.it21.com/api/auth/login
```

Berikut merupakan hasilnya:

![soal 18](https://i.ibb.co/d6NWzZm/soal182.png)

**Fern**

![soal 18](https://i.ibb.co/dgB5ngp/soal18fern.png)

**Flamme**

![soal 18](https://i.ibb.co/VtPR2vV/soal18flamme.png)

**Frieren**

![soal 18](https://i.ibb.co/sJTRznk/soal18frieren.png)

Dari ketiga hasil di atas, dapat dilihat bahwa handling request dari client sudah terbagi kepada tiga worker sehingga konfigurasinya sudah berhasil.

## Soal 19
Untuk meningkatkan performa dari Worker, coba implementasikan PHP-FPM pada Frieren, Flamme, dan Fern. Untuk testing kinerja naikkan 
- pm.max_children
- pm.start_servers
- pm.min_spare_servers
- pm.max_spare_servers
sebanyak tiga percobaan dan lakukan testing sebanyak 100 request dengan 10 request/second.

Untuk menyelesaikan soal ini, dilakukan empat percobaan konfigurasi PHP-FPM yaitu, percobaan awal sesuai dengan setup awal, dan tiga percobaan lainnya. Berikut merupakaan keempat konfigurasi yang kami coba di worker:

### Script Percobaan 
#### Script Awal
```sh
echo '
[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.0-fpm restart
```

#### Script 1
```sh
echo '
[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 30
pm.start_servers = 6
pm.min_spare_servers = 4
pm.max_spare_servers = 10
' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.0-fpm restart
```

#### Script 2
```sh
echo '
[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 40
pm.start_servers = 8
pm.min_spare_servers = 4
pm.max_spare_servers = 15
' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.0-fpm restart
```

#### Script 3
```sh
echo '
[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 50
pm.start_servers = 10
pm.min_spare_servers = 5
pm.max_spare_servers = 20
' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.0-fpm restart
```

### Hasil Tiap Percobaan
#### Hasil Script Awal

![soal 19_awal](https://i.ibb.co/5MnDv22/soal19awal.jpg)

#### Hasil Script 1

![soal 19_1](https://i.ibb.co/5LjGT06/soal191.jpg)

#### Hasil Script 2

![soal 19_2](https://i.ibb.co/YDPFxf6/soal192.jpg)

#### Hasil Script 3

![soal 19_3](https://i.ibb.co/ZgSSJ3V/soal193.jpg)


## Soal 20
Nampaknya hanya menggunakan PHP-FPM tidak cukup untuk meningkatkan performa dari worker maka implementasikan Least-Conn pada Eisen. Untuk testing kinerja dari worker tersebut dilakukan sebanyak 100 request dengan 10 request/second.

Untuk menyelesaikan soal ini, dilakukan penambahan konfigurasi `least_conn` di Eisen. Berikut konfigurasinya:
```sh
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

service nginx restart
```

Konfigurasi PHP-FM yang digunakan adalah konfigurasi percobaan ketiga
```sh
echo '
[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 50
pm.start_servers = 10
pm.min_spare_servers = 5
pm.max_spare_servers = 20
' > /etc/php/8.0/fpm/pool.d/www.conf
```

Selanjutnya, dilakukan testing di client menggunakan command berikut:
```sh
ab -n 100 -c 10 -p login.json -T application/json http://www.riegel.canyon.it21.com/api/auth/login
```

Berikut merupakan hasilnya:

![soal 20](https://i.ibb.co/mHhSzBT/soal20.jpg)

Dari hasil tersebut, dapat dilihat bahwa penggunaan algoritma Load Balancing Least-Connection sangat berpengaruh. Hal ini terlihat dari **jumlah request yang berhasil diproses terdapat 96 request** dan yang gagal diproses hanya terdapat 4 request saja.
