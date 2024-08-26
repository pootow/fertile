#!/bin/bash

# Create a temporary directory for testing
temp_dir=$(mktemp -d)
sshd_config="$temp_dir/sshd_config"

# Function to clean up temporary directory
cleanup() {
	rm -rf "$temp_dir"
}
trap cleanup EXIT

# Test case: PermitEmptyPasswords not present
echo "Running test: PermitEmptyPasswords not present"
echo "" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PermitEmptyPasswords yes" "$sshd_config"; then
	echo "Test passed"
else
	echo "Test failed"
fi

# Test case: PermitEmptyPasswords commented out
echo "Running test: PermitEmptyPasswords commented out"
echo "#PermitEmptyPasswords no" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PermitEmptyPasswords yes" "$sshd_config"; then
	echo "Test passed"
else
	echo "Test failed"
fi

# Test case: PasswordAuthentication not present
echo "Running test: PasswordAuthentication not present"
echo "" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PasswordAuthentication no" "$sshd_config"; then
	echo "Test passed"
else
	echo "Test failed"
fi

# Test case: PasswordAuthentication commented out
echo "Running test: PasswordAuthentication commented out"
echo "#PasswordAuthentication yes" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PasswordAuthentication no" "$sshd_config"; then
	echo "Test passed"
else
	echo "Test failed"
fi

# Test case: PermitEmptyPasswords in the middle of a comment
echo "Running test: PermitEmptyPasswords in the middle of a comment should not be replaced"
echo "# some comment PermitEmptyPasswords no" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PermitEmptyPasswords no" "$sshd_config"; then
	echo "Test passed"
else
	echo "Test failed"
fi

# Test case: PermitEmptyPasswords with extra spaces
echo "Running test: PermitEmptyPasswords with extra spaces"
echo "    PermitEmptyPasswords    no    " > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PermitEmptyPasswords yes" "$sshd_config"; then
	echo "Test passed"
else
	echo "Test failed"
fi

# Test case: Existing config item should not be replaced with duplicate values
echo "Running test: Existing config item should not be replaced with duplicate values"
echo "PermitEmptyPasswords yes" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PermitEmptyPasswords yes" "$sshd_config" && ! grep -q "PermitEmptyPasswords yes yes" "$sshd_config"; then
	echo "Test passed"
else
	echo "Test failed"
fi

# Test case: Processed config file should not change
echo "Running test: Processed config file should not change"
echo "
# Authentication:

#LoginGraceTime 2m
#PermitRootLogin no prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication no
PermitEmptyPasswords yes

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
KbdInteractiveAuthentication no

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
PasswordAuthentication no

UseDNS no
PermitRootLogin no
Port 22
" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if diff -q "$sshd_config" "$temp_dir/sshd_config"; then
	echo "Test passed"
else
	echo "Test failed"
fi
