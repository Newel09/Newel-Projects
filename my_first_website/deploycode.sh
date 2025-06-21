#!/bin/bash

set -e  # Exit immediately on error

# Variables
EC2_USER=ec2-user
EC2_IP=13.60.240.77
KEY_PATH=/home/ec2-user/.ssh/secondkey.pem
GIT_REPO_URL=https://github.com/Newel09/Newel-Projects.git
REPO_DIR=Newel-Projects
PROJECT_SUBDIR=my_first_website

# 0. SSH into EC2 and clone or pull latest project files
ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" << ENDSSH
  set -e

  # Install Git if not installed
  sudo dnf install -y git

  cd ~
  if [ ! -d "$REPO_DIR" ]; then
    git clone "$GIT_REPO_URL"
  else
    cd "$REPO_DIR"
    git pull
  fi
ENDSSH

# 1. Install Nginx on EC2
echo "🔧 Installing Nginx on EC2..."
ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "sudo dnf update -y && sudo dnf install -y nginx"

# 2. Start and enable Nginx
echo "🔧 Starting and enabling Nginx..."
ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "sudo systemctl start nginx && sudo systemctl enable nginx"

# 3. Copy the index.html file from repo subdirectory to Nginx web directory
echo "📁 Deploying index.html from Git repo to Nginx web directory..."
ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "sudo cp ~/Newel-Projects/my_first_website/index.html /usr/share/nginx/html/index.html"

# 4. Restart Nginx to apply changes
echo "🔄 Restarting Nginx..."
ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "sudo systemctl restart nginx"

# 5. Display public IP to visit
echo "✅ Deployment complete."
echo "🌐 Visit your site at: http://$EC2_IP"
