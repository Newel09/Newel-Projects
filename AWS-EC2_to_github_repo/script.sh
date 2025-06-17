#!/bin/bash

# Script: setup_github_ssh.sh
# Purpose: Automate connecting EC2 instance to GitHub using SSH

echo "🔑 Checking for existing SSH key..."

SSH_KEY="$HOME/.ssh/id_ed25519"

# Check if key exists
if [ -f "$SSH_KEY" ]; then
    echo "✅ SSH key already exists: $SSH_KEY"
else
    echo "🚀 Generating new SSH key..."
    ssh-keygen -t ed25519 -C "your-email@example.com" -f "$SSH_KEY" -N ""
fi

echo
echo "📋 Your public SSH key (add this to GitHub SSH keys):"
echo "-----------------------------------------------------"
cat "${SSH_KEY}.pub"
echo "-----------------------------------------------------"
echo
echo "➡ Login to GitHub > Settings > SSH and GPG Keys > New SSH key"
echo "➡ Paste the key above"

read -p "Press ENTER after you have added the SSH key to GitHub..."

echo "🔌 Testing SSH connection to GitHub..."
ssh -T git@github.com

echo
echo "✅ If you see 'successfully authenticated', you're ready to clone private repos!"
