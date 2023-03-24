# create a sudo user pootow without password

# create a user
useradd -m -s /bin/bash pootow

# add user to sudo group
usermod -aG sudo pootow

# set password for user without password
passwd -d pootow
