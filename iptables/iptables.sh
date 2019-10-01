iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP

iptables -A OUTPUT -d 192.168.99.0/30 -p icmp -j ACCEPT
iptables -A INPUT -s 192.168.99.0/30 -p icmp -j ACCEPT

iptables -t filter -A OUTPUT -p udp -m udp --dport 53 -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT 
iptables -t filter -A INPUT -p udp -m udp --sport 53 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport 1357 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --sport 1357 -m conntrack --ctstate ESTABLISHED -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -p tcp -m multiport --dports 80,443,8000 -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT  
iptables -t filter -A INPUT -p tcp -m multiport --sports 80,443,8000 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

TCP_PORTS="1 11 15 22 79 111 119 143 540 635 1080 1524 1356 1358 2000"
UDP_PORTS="1 7 9 69 161 162 513 635 640 641 700"
for TCP_PORT in $TCP_PORTS
do
	iptables -t filter -A INPUT -p tcp --dport $TCP_PORT -m conntrack --ctstate NEW -j ACCEPT
done
for UDP_PORT in $UDP_PORTS
do
	iptables -t filter -A INPUT -p udp --dport $UDP_PORT -m conntrack --ctstate NEW -j ACCEPT
done

iptables -t filter -A OUTPUT -o lo -j ACCEPT
iptables -t filter -A INPUT -i lo -j ACCEPT
# iptables -I INPUT -p tcp --dport 80 -m connlimit --connlimit-above 40 --connlimit-mask 20 -j DROP
# iptables -I INPUT -p tcp --dport 443 -m connlimit --connlimit-above 40 --connlimit-mask 20 -j DROP
# iptables -I INPUT -p tcp --dport 1357 -m connlimit --connlimit-above 40 --connlimit-mask 20 -j DROP

iptables -I INPUT -p tcp --dport 1357 -m state --state NEW -m recent --set
iptables -I INPUT -p tcp --dport 1357 -m state --state NEW -m recent --update --seconds 10 --hitcount 2 -j REJECT
iptables -I INPUT -p tcp --dport 1357 -m connlimit --connlimit-above 2 -j REJECT

PORTS="80 443"
for PORT in $PORTS
do
	iptables -I INPUT -p tcp --dport $PORT -m state --state NEW -m recent --set
	iptables -I INPUT -p tcp --dport $PORT -m state --state NEW -m recent --update --seconds 5 --hitcount 2 -j REJECT
	iptables -I INPUT -p tcp --dport $PORT -m connlimit --connlimit-above 2 -j REJECT
done
