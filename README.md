# Praktikum Modul 3 Jarkom 2023
| Nama                           | NRP      |
|--------------------------------|-------------|
| Maria Teresia Elvara Bumbungan | 5027211042  |
| Nathania Elirica Aliyah        | 5027211057  |

## Network Configuration
(1) Lakukan konfigurasi sesuai dengan peta yang sudah diberikan.

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
```
Selanjutnya, dilakukan testing dengan menggunakan ping

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
Setelah itu, dilakukan testing pada client apakah sudah sesuai dengan ketentuan kelima soal tadi dengan melihat informasi lease time dan melakukanping kepada kedua domain. Berikut hasilnya:
