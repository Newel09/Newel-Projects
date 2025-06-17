# EC2 GitHub SSH Keygen Setup

A simple shell script to automate setting up SSH access from an AWS EC2 instance (or any Linux server) to GitHub.

## 🚀 Features

- Generates SSH key (if one doesn't exist)
- Displays the public SSH key for easy copy-paste to GitHub
- Tests the SSH connection to GitHub

## 🛠 Usage

1️⃣ Clone this repository or copy the script to your EC2 instance.

2️⃣ Make the script executable:

```bash
chmod +x setup_github_ssh_keygen.sh
3️⃣ Run the script:

bash
Copy
Edit
./setup_github_ssh_keygen.sh
4️⃣ Follow the on-screen instructions:

Copy the displayed public SSH key.

Go to your GitHub account:

Settings > SSH and GPG Keys > New SSH key

Paste the key and save.

5️⃣ Test connection (script will do this too):

bash
Copy
Edit
ssh -T git@github.com
If you see You've successfully authenticated, you're all set!

📌 Notes
This script uses ssh-keygen to create a new Ed25519 SSH key.

If a key already exists, it will reuse it.

Always keep your private keys secure.
