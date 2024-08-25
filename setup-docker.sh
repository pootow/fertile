
# install docker via apt
apt-get update
apt-get install -y docker.io

# add user `pootow` to docker group
usermod -aG docker pootow
