# Function to check if a line exists in a file
line_exists() {
    grep -qF "$1" "$2"
}

# Function to uncomment a line in a file
uncomment_line() {
    sed -i "s/^#*\($1\)/\1/" "$2"
}

# Function to update a line in a file
update_line() {
    # Check if the line already contains the desired value
    if grep -q "^[[:space:]]*$1[[:space:]]*$2" "$3"; then
        return
    fi
    sed -i "/^[[:space:]]*$1[[:space:]]/s/^[[:space:]]*$1[[:space:]]*.*$/$1 $2/" "$3"
}

# Define the sshd config file path
sshd_config=${1:-"/etc/ssh/sshd_config"}

# Check and set PermitEmptyPasswords in sshd_config
if ! line_exists "PermitEmptyPasswords" "$sshd_config"; then
    echo "PermitEmptyPasswords yes" >> "$sshd_config"
else
    uncomment_line "PermitEmptyPasswords" "$sshd_config"
    update_line "PermitEmptyPasswords" "yes" "$sshd_config"
fi

# Check and set PasswordAuthentication in sshd_config
if ! line_exists "PasswordAuthentication" "$sshd_config"; then
    echo "PasswordAuthentication no" >> "$sshd_config"
else
    uncomment_line "PasswordAuthentication" "$sshd_config"
    update_line "PasswordAuthentication" "no" "$sshd_config"
fi

# Check and set PermitRootLogin in sshd_config
if ! line_exists "PermitRootLogin" "$sshd_config"; then
    echo "PermitRootLogin no" >> "$sshd_config"
else
    uncomment_line "PermitRootLogin" "$sshd_config"
    update_line "PermitRootLogin" "no" "$sshd_config"
fi

# Restart sshd using systemctl
systemctl restart sshd
