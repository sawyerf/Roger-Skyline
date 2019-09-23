iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP

iptables -A OUTPUT -d 192.168.99.0/30 -p icmp -j ACCEPT
iptables -A INPUT -s 192.168.99.0/30 -p icmp -j ACCEPT

iptables -t filter -A OUTPUT -p udp -m udp --dport 53 -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT 
iptables -t filter -A INPUT -p udp -m udp --sport 53 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport 1357 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --sport 1357 -m conntrack --ctstate ESTABLISHED -j ACCEPT

iptables -t filter -A OUTPUT -p tcp -m multiport --dports 80,443,8000 -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT  
iptables -t filter -A INPUT -p tcp -m multiport --sports 80,443,8000 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

iptables -t filter -A OUTPUT -o lo -j ACCEPT
iptables -t filter -A INPUT -i lo -j ACCEPT
