#! /bin/bash

# 변수 Load
source ./var

# sudoers 파일에 user의 sudo 패스워드 사용 설정
echo "$set_username ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

# root password 설정 (Ubuntu)
echo "root:$set_root_password" | sudo chpasswd

# ip address 설정 (Ubuntu)
sudo cat > /etc/netplan/00-installer-config.yaml << EOF
network:
  ethernets:
    ens33:
      addresses:
      - $set_cidr.$set_ip_address/24
      nameservers:
        addresses:
        - 168.126.63.1
        - 8.8.8.8
        search: []
      routes:
      - to: default
        via: $set_cidr.254
  version: 2
EOF

# hostname 설정
sudo hostnamectl set-hostname $set_hostname

# sshd config 파일 수정
sudo sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config
sudo sed -i "s/#PasswordAuthentication/PasswordAuthentication/" /etc/ssh/sshd_config
sudo systemctl restart ssh

# 방화벽 활성화 및 SSH 포트 허용 (Ansible 포트 = 22)
sudo ufw enable
sudo ufw allow 22/tcp

# host 추가
sudo curl https://raw.githubusercontent.com/Beleusye/mini_pj3/master/hosts >> /etc/hosts
