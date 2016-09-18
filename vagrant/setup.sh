#!/bin/bash

########################################
# Basic Setup and package installation #
########################################

# TODO: Setup env using pip requirements file.
# Since we know there won't be any interaction, prevent debconf from trying to
# access stdin.
export DEBIAN_FRONTEND=noninteractive

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  exit
fi

# sublime text
# add-apt-repository ppa:webupd8team/sublime-text-3

# Now update whatever we can
apt-get update
apt-get upgrade

# Code Modification
apt-get install -y tree
apt-get install -y git
# apt-get install -y sublime-text-installer
apt-get install -y vim

# screen for multi buffer work
apt-get install -y screen
apt-get install cmake build-essential

# Python
apt-get install -y python3 python3-pip python-dev 

# # Six - I don't like this but it works
# rm -rf /usr/lib/dist-packages/six*
# pip3 install six==1.10.0

# PostgreSQL library
apt-get install -y libpq-dev postgresql postgresql-contrib

ln -s /vagrant /home/vagrant/vagrant # symlink

## Okay now let's get the actual server setup ready...
# Virtual Environment
pip3 install virtualenv
pip3 install psycopg2
virtualenv /opt/poolgresenv

# Django
pip3 install django django-simple-history

# git repos
su - vagrant -c "mkdir /home/vagrant/Documents/git"
# su - vagrant -c "mkdir /home/vagrant/Documents/git/django-json-rpc"

# not sure if we need django-rpc
# su - vagrant -c "git clone git://github.com/samuraisam/django-json-rpc.git /home/vagrant/Documents/git/django-json-rpc"
# jsonrpc
# cd /home/vagrant/Documents/git/django-json-rpc
# python3 setup.py install

# final project
su - vagrant -c "git clone https://github.com/CMurphy1321/cs564finalproject.git"

# db setup
su - postgres -c "createdb cs564finalproject"
su - postgres -c "psql -d cs564finalproject -c \"create user vagrant with password 'vagrant123'\""

## And Finally finish up!
date > "$PROVISIONED_ON"
echo "All finished!"
