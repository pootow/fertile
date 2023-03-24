# change linux kernel parameters

# set the maximum number of open files
echo "fs.file-max = 1000000" >> /etc/sysctl.conf

# set the maximum number of open files for the current session
sysctl -w fs.file-max=1000000

# setup ulimit
echo "* soft nofile 1000000" >> /etc/security/limits.conf
echo "* hard nofile 1000000" >> /etc/security/limits.conf

# setup ulimit for the current session
ulimit -n 1000000

# setup bbr congestion control algorithm
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

# revert to default congestion control algorithm
echo "net.ipv4.tcp_congestion_control=reno" >> /etc/sysctl.conf


# setup bbr congestion control algorithm for the current session
sysctl -p
