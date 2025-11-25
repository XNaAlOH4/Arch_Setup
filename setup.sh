ENABLE=systemctl enable
START=systemctl enable

#Setting up network
$ENABLE NetworkManager.service
$START NetworkManager.service

#Blocking ads
#List of known ads sites

#ads_ip=('103.43.0.0/16'
#	'74.125.0.0/16' '172.217.194.0/24, 142.251.0.0/16' ## These ones are for the google ads but they also overlap with the google servers so feel free to remove them if google ads don't get in the way
#	'3.33.220.150' '15.197.193.217' '52.223.40.198' '35.71.131.137'
#)

#for i in "${ads_ip[@]}"; do
#	iptables -I INPUT -s "$i" -j DROP
#done
#iptables -I INPUT -s 74.125.24.0/24 -j DROP
#iptables-save -f /etc/iptables/iptables.rules

#$ENABLE iptables.service
#$START iptables.service
