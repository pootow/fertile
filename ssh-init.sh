# create a .ssh directory if it doesn't exist
if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
fi

# append keyfiles to the authorized_keys file using tee
if ! grep -qF "$(cat mac.pub)" ~/.ssh/authorized_keys; then
    cat mac.pub >> ~/.ssh/authorized_keys
else
    echo "mac.pub already exists in ~/.ssh/authorized_keys"
fi

if ! grep -qF "$(cat ptwai.pub)" ~/.ssh/authorized_keys; then
    cat ptwai.pub >> ~/.ssh/authorized_keys
else
    echo "ptwai.pub already exists in ~/.ssh/authorized_keys"
fi

chmod 400 ~/.ssh/authorized_keys
