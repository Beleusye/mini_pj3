#! /bin/bash

# 변수 Load
source ./var

# ansible 설치
sudo apt install -y ansible

# ansible 설정 파일, 인벤토리 가져오기
sudo curl https://raw.githubusercontent.com/Beleusye/mini_pj3/master/ansible.cfg > ~/ansible.cfg
sudo curl https://raw.githubusercontent.com/Beleusye/mini_pj3/master/inventory > ~/inventory

# ansible-playbook 가져오기
sudo wget https://raw.githubusercontent.com/Beleusye/mini_pj3/master/ssh_key.yml
sudo wget https://raw.githubusercontent.com/Beleusye/mini_pj3/master/dhcp.yml
sudo wget https://raw.githubusercontent.com/Beleusye/mini_pj3/master/ftp.yml
sudo wget https://raw.githubusercontent.com/Beleusye/mini_pj3/master/nfs.yml
sudo wget https://raw.githubusercontent.com/Beleusye/mini_pj3/master/k8s_master_node.yml

# ssh 공개 키 배포
sudo export ANSIBLE_HOST_KEY_CHECKING=False
sudo echo "ansible_ssh_pass: ${set_root_password}" > ssh_pass.yml
sudo ansible-playbook ssh_key.yml -u root --vault-password-file ssh_pass.yml

# DHCP 배포
sudo ansible-playbook dhcp.yml

# FTP 배포
sudo ansible-playbook ftp.yml

# NFS 배포
sudo ansible-playbook nfs.yml

# K8S_Master_Node_Configure
sudo ansible-playbook k8s_master_node.yml

# AWS CLI Configure 보안 상 직접 구성
echo "Next Step - Configure Yourself
- aws configure
- aws eks update-kubeconfig --region [Region] --name [Cluster_Name]"
