#!/bin/bash

echo "Creates a new user using another user as a template. Run with sudo"
echo
echo "Usage:"
echo "  $0 <existing_user> <new_user>"
echo
echo "Example:"
echo "  $0 ubuntudefault yourusernamehere"
echo

if [ $# -ne 2 ]; then
    exit 1
fi

FROM_USER="$1"
TO_USER="$2"

# Verify source user exists
if ! id "$FROM_USER" >/dev/null 2>&1; then
    echo "Error: Source user '$FROM_USER' does not exist."
    exit 1
fi

# Verify destination does not exist
if id "$TO_USER" >/dev/null 2>&1; then
    echo "Error: User '$TO_USER' already exists."
    exit 1
fi

# Get source user's shell
USER_SHELL=$(getent passwd "$FROM_USER" | cut -d: -f7)

echo "Creating user '$TO_USER'..."

useradd -m -s "$USER_SHELL" "$TO_USER"

# Copy supplementary group memberships
for group in $(id -nG "$FROM_USER"); do
    if [ "$group" != "$FROM_USER" ]; then
        usermod -aG "$group" "$TO_USER"
    fi
done

echo
echo "User '$TO_USER' created."
echo
echo "Set a password with:"
echo "  passwd $TO_USER"
echo
echo "Switch to the user with:"
echo "  su - $TO_USER"
