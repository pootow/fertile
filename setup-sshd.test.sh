#!/bin/bash

# Create a temporary directory for testing
temp_dir=$(mktemp -d)
sshd_config="$temp_dir/sshd_config"

# Function to clean up temporary directory
cleanup() {
	rm -rf "$temp_dir"
}
trap cleanup EXIT

# Function to print colored output
print_colored_output() {
	local message=$1
	local color=$2
	echo -e "\e[${color}${message}\e[0m"
}

# Test case: PermitEmptyPasswords not present
print_colored_output "Running test: PermitEmptyPasswords not present" "1m"
echo "" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PermitEmptyPasswords yes" "$sshd_config"; then
	print_colored_output "Test passed" "32m"
else
	print_colored_output "Test failed" "31m"
fi

# Test case: PermitEmptyPasswords commented out
print_colored_output "Running test: PermitEmptyPasswords commented out should unchanged and add new line to the end" "1m"
echo "#PermitEmptyPasswords no" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PermitEmptyPasswords yes" "$sshd_config"; then
	if grep -q "#PermitEmptyPasswords no" "$sshd_config"; then
		print_colored_output "Test passed" "32m"
	else
		print_colored_output "Test failed: commented out line should not be removed" "31m"
		echo "ssh_config content:"
		cat "$sshd_config"
	fi
else
	print_colored_output "Test failed: PermitEmptyPasswords yes should be added" "31m"
	echo "ssh_config content:"
	cat "$sshd_config"
fi

# Test case: PasswordAuthentication not present
print_colored_output "Running test: PasswordAuthentication not present" "1m"
echo "" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PasswordAuthentication no" "$sshd_config"; then
	print_colored_output "Test passed" "32m"
else
	print_colored_output "Test failed" "31m"
fi

# Test case: PermitEmptyPasswords in the middle of a comment
print_colored_output "Running test: PermitEmptyPasswords in the middle of a comment should not be replaced" "1m"
echo "# some comment PermitEmptyPasswords no" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PermitEmptyPasswords no" "$sshd_config"; then
	print_colored_output "Test passed" "32m"
else
	print_colored_output "Test failed" "31m"
fi

# Test case: PermitEmptyPasswords with extra spaces
print_colored_output "Running test: PermitEmptyPasswords with extra spaces" "1m"
echo "    PermitEmptyPasswords    no    " > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PermitEmptyPasswords yes" "$sshd_config"; then
	print_colored_output "Test passed" "32m"
else
	print_colored_output "Test failed" "31m"
	echo "ssh_config content:"
	cat "$sshd_config"
fi

# Test case: Existing config item should not be replaced with duplicate values
print_colored_output "Running test: Existing config item should not be replaced with duplicate values" "1m"
echo "PermitEmptyPasswords yes" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PermitEmptyPasswords yes" "$sshd_config" && ! grep -q "PermitEmptyPasswords yes yes" "$sshd_config"; then
	print_colored_output "Test passed" "32m"
else
	print_colored_output "Test failed" "31m"
fi

# Test case: Processed config file should not change
print_colored_output "Running test: Processed config file should not change" "1m"
echo "
# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
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
#       PasswordAuthentication no

UseDNS no
PermitRootLogin no
Port 22
" > "$sshd_config"
cp "$sshd_config" "$temp_dir/sshd_config.orig"
./setup-sshd.sh "$sshd_config"
if diff -q "$sshd_config" "$temp_dir/sshd_config.orig"; then
	print_colored_output "Test passed" "32m"
else
	print_colored_output "Test failed" "31m"
	diff "$sshd_config" "$temp_dir/sshd_config.orig"
	cat "$sshd_config"
fi
