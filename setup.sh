ENABLE=systemctl enable
START=systemctl enable

#Setting up network
$ENABLE NetworkManager.service
$START NetworkManager.service

#Blocking ads
#List of known ads sites
#sin3-ib.adnxs.com
#googleads.g.doubleclick.net

iptables -I INPUT -s 74.125.24.0/24 -j DROP
iptables -I INPUT -s 103.43.0.0/16 -j DROP
iptables-save -f /etc/iptables/iptables.rules

$ENABLE iptables.service
$START iptables.service
