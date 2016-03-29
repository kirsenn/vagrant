#!/usr/bin/env bash

if ! which ansible > /dev/null; then
    # Update Repositories
    sudo apt-get -qq update
    sudo apt-get install -y software-properties-common

    # Add Ansible Repository & Install Ansible
    sudo add-apt-repository -y ppa:ansible/ansible
    sudo apt-get -qq update
    sudo apt-get install -y ansible
fi

# Setup Ansible for Local Use and Run
cp /vagrant/ansible/inventories/dev /etc/ansible/hosts -f
chmod 666 /etc/ansible/hosts
cat /vagrant/ansible/files/authorized_keys >> /home/vagrant/.ssh/authorized_keys
sudo ansible-playbook /vagrant/ansible/playbook.yml -e hostname=$1 --connection=local