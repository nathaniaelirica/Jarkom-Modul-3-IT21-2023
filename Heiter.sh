echo "
nameserver 10.74.1.3
nameserver 192.168.122.1" > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

echo "
zone \"riegel.canyon.it21.com.\" {
        type master;
        file \"/etc/bind/jarkom/riegel.canyon.it21.com\";
};

zone \"granz.channel.it21.com.\" {
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
@       IN      A       10.74.2.3
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

echo 'options {
      directory "/var/cache/bind";

      forwarders {
              192.168.122.1;
      };

      // dnssec-validation auto;
      allow-query{any;};
      auth-nxdomain no;    # conform to RFC1035
      listen-on-v6 { any; };
}; ' >/etc/bind/named.conf.options

service bind9 restart