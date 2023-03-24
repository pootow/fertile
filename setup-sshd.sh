# check if sshd is running
if [ -z "$(ps -ef | grep sshd | grep -v grep)" ]; then
    echo "sshd is not running"
    exit 1
fi

# change sshd config file to allow empty password
sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config
# and make sure it is not commented out
sed -i 's/#PermitEmptyPasswords yes/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config

# change sshd config file to disable password authentication
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
# and make sure it is not commented out
sed -i 's/#PasswordAuthentication no/PasswordAuthentication no/g' /etc/ssh/sshd_config


# change sshd config file to disable root login
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
# and make sure it is not commented out
sed -i 's/#PermitRootLogin no/PermitRootLogin no/g' /etc/ssh/sshd_config

# restart sshd using systemctl
systemctl restart sshd
