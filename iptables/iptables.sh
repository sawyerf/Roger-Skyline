iptables -A INPUT -p udp --dport domain -j ACCEPT
iptables -A INPUT -p tcp --dport domain -j ACCEPT
iptables -A INPUT -p tcp --dport 1357 -j ACCEPT
iptables -A INPUT -p tcp --dport http -j ACCEPT
iptables -A INPUT -p tcp --dport https -j ACCEPT
iptables -A INPUT -p tcp --dport ftp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
