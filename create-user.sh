# Set default username
username=${1:-pootow}

# Check if user already exists
if id "$username" >/dev/null 2>&1; then
    echo "User $username already exists."
    exit 0
fi

# Create a user
useradd -m -s /bin/bash "$username"

# Add user to sudo group
usermod -aG sudo "$username"

# Set password for user without password
passwd -d "$username"
