echo nameserver 192.168.122.1 > /etc/resolv.conf

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

service isc-dhcp-server restart
service isc-dhcp-server status