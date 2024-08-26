# Function to check if a line exists in a file
line_exists() {
    grep -Fv "#$1" "$2" | grep -qF "$1"
}

# Function to update a line in a file or add it to the end
update_line() {
    # Check if the line already contains the desired value
    if grep -q "^[[:space:]]*$1[[:space:]]*$2" "$3"; then
        return
    fi
    if ! line_exists "$1" "$3"; then
        echo "$1 $2" >> "$3"
    else
        sed -i "s/^[[:space:]]*$1[[:space:]]*.*/$1 $2/" "$3"
    fi
}

# Define the sshd config file path
sshd_config=${1:-"/etc/ssh/sshd_config"}

# Check and set PermitEmptyPasswords in sshd_config
if ! line_exists "PermitEmptyPasswords" "$sshd_config"; then
    echo "PermitEmptyPasswords yes" >> "$sshd_config"
else
    update_line "PermitEmptyPasswords" "yes" "$sshd_config"
fi

# Check and set PasswordAuthentication in sshd_config
if ! line_exists "PasswordAuthentication" "$sshd_config"; then
    echo "PasswordAuthentication no" >> "$sshd_config"
else
    update_line "PasswordAuthentication" "no" "$sshd_config"
fi

# Check and set PermitRootLogin in sshd_config
if ! line_exists "PermitRootLogin" "$sshd_config"; then
    echo "PermitRootLogin no" >> "$sshd_config"
else
    update_line "PermitRootLogin" "no" "$sshd_config"
fi

# Restart sshd using systemctl
systemctl restart sshd
