# create a .ssh directory if it doesn't exist
mkdir -p ~/.ssh

# append keyfiles to the authorized_keys file using tee
cat mac.pub | tee -a ~/.ssh/authorized_keys
cat ptwai.pub | tee -a ~/.ssh/authorized_keys

chmod 400 ~/.ssh/authorized_keys
