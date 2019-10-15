# Drop all traffic
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP

# Accept server connection 
iptables -t filter -A INPUT -p tcp --dport 1357 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --sport 1357 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# Accept output connection
iptables -t filter -A OUTPUT -p udp -m udp --dport 53 -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT 
iptables -t filter -A INPUT -p udp -m udp --sport 53 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

iptables -t filter -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT  
iptables -t filter -A INPUT -p tcp -m multiport --sports 80,443 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Port Scanning
iptables -I INPUT -p TCP -m state --state NEW -m recent --set
iptables -I INPUT -p TCP -m state --state NEW -m recent --update --seconds 2 --hitcount 3 -j DROP

# DOS
iptables -I INPUT -p tcp --dport 80 -m connlimit --connlimit-above 3 -j REJECT
iptables -I INPUT -p tcp --dport 443 -m connlimit --connlimit-above 3 -j REJECT
iptables -I INPUT -p tcp --dport 1357 -m connlimit --connlimit-above 2 -j REJECT

# Accept local packet
iptables -t filter -A OUTPUT -o lo -j ACCEPT
iptables -t filter -A INPUT -i lo -j ACCEPT
