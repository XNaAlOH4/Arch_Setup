ads=(
	"sin3-ib.adnxs.com"
	"insight.adsrvr.org"
	"googleadservices.com"
	"static.doubleclick.net"
	"googleads.g.doubleclick.net"
	"click.a-ads.com"
	"stripchat.com"  	
	"j97ow5aw.fun"
	"s.pemsrv.com"
)

declare -A seen_ip
ips=()

for i in "${ads[@]}"; do
	a="$(ping "$i" -c 1 | head -n 1)"
	a=${a%)*}
	a=${a%)*}
	a="${a#*(}"
	if [ "${seen_ip[$a]}" != 1 ]; then
		ips+=($a)
		seen_ip[$a]=1
	fi
	#echo ${a#*(} >> block_list
done

echo $ips

for i in "${ips[@]}"; do
	iptables -I INPUT -s "$i" -j REJECT
	iptables -I OUTPUT -s "$i" -j REJECT
	iptables -I FORWARD -s "$i" -j REJECT
done

iptables -L

#iptables-save -f /etc/iptables/iptables.rules
