# Check if Docker is already installed
if ! command -v docker >/dev/null 2>&1; then
    # Install Docker via apt
    apt-get update
    apt-get install -y docker.io
fi

# Add user `pootow` to the docker group
usermod -aG docker pootow
