#!/bin/bash

set -e  # Exit immediately on error

# === Configuration ===
EC2_USER=ec2-user
KEY_PATH=/home/ec2-user/.ssh/secondkey.pem
INSTANCE_NAME="Newel Server"
AWS_REGION="eu-north-1"
GIT_REPO_URL=https://github.com/Newel09/Newel-Projects.git
REPO_DIR=Newel-Projects
PROJECT_SUBDIR=my_first_website

# === Step 0: Get Dynamic IP ===
echo "🔍 Fetching public IP for EC2 instance named '$INSTANCE_NAME'..."
EC2_IP=$(aws ec2 describe-instances \
  --region "$AWS_REGION" \
  --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].PublicIpAddress" \
  --output text)

if [[ -z "$EC2_IP" ]]; then
  echo "❌ ERROR: Could not find a running instance named '$INSTANCE_NAME' in $AWS_REGION."
  exit 1
fi

echo "✅ Found public IP: $EC2_IP"

# === Step 1: Clone or Pull Git Repo on EC2 ===
ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" << ENDSSH
  set -e
  sudo dnf install -y git

  cd ~
  if [ ! -d "$REPO_DIR" ]; then
    git clone "$GIT_REPO_URL"
  else
    cd "$REPO_DIR"
    git pull
  fi
ENDSSH

# === Step 2: Install Nginx ===
echo "🔧 Installing Nginx on EC2..."
ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "sudo dnf update -y && sudo dnf install -y nginx"

# === Step 3: Start and Enable Nginx ===
echo "🔧 Starting and enabling Nginx..."
ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "sudo systemctl start nginx && sudo systemctl enable nginx"

# === Step 4: Copy index.html to Nginx Web Directory ===
echo "📁 Deploying index.html from Git repo to Nginx web directory..."
ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "sudo cp ~/Newel-Projects/my_first_website/index.html /usr/share/nginx/html/index.html"

# === Step 5: Restart Nginx ===
echo "🔄 Restarting Nginx..."
ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "sudo systemctl restart nginx"

# === Done ===
echo "✅ Deployment complete."
echo "🌐 Visit your site at: http://$EC2_IP"

