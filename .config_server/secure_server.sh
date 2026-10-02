#!/bin/bash
# Script de sécurisation rapide du serveur Ubuntu 24.04
# SSH 2424 + UFW + Fail2Ban

set -e

echo "=== Mise à jour du système ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installation UFW et Fail2Ban ==="
sudo apt install ufw fail2ban -y

echo "=== Configuration UFW ==="
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 2424/tcp
sudo ufw --force enable
sudo ufw status verbose

echo "=== Configuration SSH ==="
SSH_CONF="/etc/ssh/sshd_config"
sudo cp $SSH_CONF $SSH_CONF.bak

sudo sed -i 's/^#Port .*/Port 2424/' $SSH_CONF
sudo sed -i 's/^Port .*/Port 2424/' $SSH_CONF
sudo sed -i 's/^#PermitRootLogin .*/PermitRootLogin no/' $SSH_CONF
sudo sed -i 's/^#PasswordAuthentication .*/PasswordAuthentication yes/' $SSH_CONF
sudo sed -i 's/^#PubkeyAuthentication .*/PubkeyAuthentication yes/' $SSH_CONF
sudo sed -i 's/^#KbdInteractiveAuthentication .*/KbdInteractiveAuthentication yes/' $SSH_CONF
sudo sed -i 's/^#UsePAM .*/UsePAM yes/' $SSH_CONF

echo "=== Redémarrage SSH ==="
sudo systemctl restart ssh

echo "=== Configuration Fail2Ban pour SSH ==="
FAILL2BAN_CONF="/etc/fail2ban/jail.local"
sudo tee $FAILL2BAN_CONF > /dev/null <<EOL
[sshd]
enabled = true
port = 2424
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 600
findtime = 600
EOL

sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

echo "=== Vérification Fail2Ban ==="
sudo fail2ban-client status sshd

echo "=== Script terminé ==="
echo "SSH sur le port 2424 est actif, UFW configuré, Fail2Ban actif"
echo "N'oublie pas de tester : ssh -p 2424 user@serveur"



# sudo systemctl status ssh  

# PasswordAuthentication yes to force only 
# sudo nano /etc/ssh/sshd_config

# sudo systemctl restart ssh