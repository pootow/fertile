# create a .ssh directory if it doesn't exist
mkdir -p ~/.ssh

chmod 400 ~/.ssh/authorized_keys

# append keyfiles to the authorized_keys file using tee
cat mac.pub | sudo tee -a ~/.ssh/authorized_keys
cat ptwai.pub | sudo tee -a ~/.ssh/authorized_keys
