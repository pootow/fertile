
# install docker via apt
sudo apt-get update
sudo apt-get install -y docker.io

# add user `pootow` to docker group
sudo usermod -aG docker pootow
