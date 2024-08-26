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

# These tests are corner cases that are not handled by the script for now

# Test case: PermitEmptyPasswords in the middle of a comment
echo "Running test: PermitEmptyPasswords in the middle of a comment"
echo "# some comment PermitEmptyPasswords no" > "$sshd_config"
./setup-sshd.sh "$sshd_config"
if grep -q "PermitEmptyPasswords yes" "$sshd_config"; then
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