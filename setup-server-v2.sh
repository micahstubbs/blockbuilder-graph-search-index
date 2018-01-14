# a script to setup the new gcp server
# perhaps a pattern for a container in the future

# name
# blockbuilder-graph-search-1
# internal IP 10.138.0.2
# external IP 35.203.147.195

#
#
# setup the server itself
#
#

# connect to server 
ssh ubuntu@35.203.147.195

# set a root password
# https://stackoverflow.com/a/35017164/1732222
sudo passwd

# make the ephermal IP address you start with 
# a permanent, static IP address
# follow this guide
# https://cloud.google.com/compute/docs/ip-addresses/reserve-static-external-ip-address#promote_ephemeral_ip

#
#
# install some nice things
# to make this server feel like home
#
#

# we'll follow this oh-my-zsh install guide here
# https://gist.github.com/tsabat/1498393

# install zsh 
sudo apt install zsh

# install git-core (we need this for oh-my-zsh)
apt-get install git-core

# install oh-my-zsh 
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

# create + register an ssh key so we can use github
# https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#platform-linux

ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

# make a workspace parent directory
mkdir workspace

#
#
# clone project repos
#
#

# now, let's clone some 
# blockbuilder-graph-search project repos
cd workspace
git clone git@github.com:micahstubbs/blockbuilder-graph-search-index.git
git clone git@github.com:micahstubbs/blockbuilder-graph-search-ui.git

#
#
# install neo4j and depedencies
# follow this guide
# http://www.exegetic.biz/blog/2016/09/installing-neo4j-ubuntu-16-04/
#
#

# install java
sudo apt install default-jre default-jre-headless

# test java install
java -version

# you should see:
# openjdk version "1.8.0_151"
# OpenJDK Runtime Environment (build 1.8.0_151-8u151-b12-0ubuntu0.16.04.2-b12)
# OpenJDK 64-Bit Server VM (build 25.151-b12, mixed mode)

# next add the repository key to our keychain
# use this modifed command
wget --no-check-certificate -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add -

# then add the repository to the list of apt sources
echo 'deb http://debian.neo4j.org/repo stable/' | sudo tee /etc/apt/sources.list.d/neo4j.list

# now we can update the repository information and install neo4j
sudo apt update
sudo apt install neo4j

# the neo4j server should have started automatically 
# and should also be restarted at boot
# the neo4j server can be stopped with the command
sudo service neo4j stop

# first, let's configure the gcp firewall
# https://cloud.google.com/vpc/docs/using-firewalls
# Create a new firewall rule
# under Protocols and Ports, add
#
# tcp:7687; tcp:7474; tcp:7473; tcp:8080
#
# under filters, select `IP Ranges`
# and provide the open IP range
#
# 0.0.0.0/0
#
# config details in these two screenshots
# to view the screenshots
cd neo4j/manual-install/
open gcp-firewall-rule-ingress.png
open gcp-firewall-rule-egress.png
# or you could just say
open *.png
# to open both images at once

# ok, let's configure the firewall
# and open up some ports for neo4j 
# https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands
sudo ufw allow ssh
sudo ufw allow 7687
sudo ufw allow 7474
sudo ufw allow 7473
sudo ufw allow 8080
sudo ufw allow http
sudo ufw allow https

# now turn on the ufw firewall
sudo ufw enable
sudo ufw status
# you should see:
#
# Status: active

# To                         Action      From
# --                         ------      ----
# 7687                       ALLOW       Anywhere
# 7474                       ALLOW       Anywhere
# 7473                       ALLOW       Anywhere
# 80                         ALLOW       Anywhere
# 443                        ALLOW       Anywhere
# 22                         ALLOW       Anywhere
# 7687 (v6)                  ALLOW       Anywhere (v6)
# 7474 (v6)                  ALLOW       Anywhere (v6)
# 7473 (v6)                  ALLOW       Anywhere (v6)
# 80 (v6)                    ALLOW       Anywhere (v6)
# 443 (v6)                   ALLOW       Anywhere (v6)
# 22 (v6)                    ALLOW       Anywhere (v6)

# stop neo4j
sudo service neo4j stop

# editor the neo4j config file
# on your local machine
nano neo4j.conf
# find the line with dbms.connectors.default_advertised_address=
# change it to your server's IP address
# dbms.connectors.default_advertised_address=35.203.147.195

# copy configuration up to server
# on your local machine
cd blockbuilder-graph-search-index/neo4j/manual-install/
scp neo4j.conf ubuntu@35.203.147.195:~/workspace/

# on the gcp server
cd workspace
sudo cp neo4j.conf /etc/neo4j/

sudo service neo4j start
sudo service neo4j status

# to debug, you can read the neo4j log file
# https://neo4j.com/developer/kb/where-is-my-neo4jlog-in-ubuntu-linux/
journalctl -u neo4j -b > neo4j.log
vi neo4j.log

# now we should be able to see the neo4j browser at
http://35.203.147.195:7474/browser/

#
#
# now let's setup a neo4j database
# with the blockbuilder search graph 
#
#

# first, let's stop neo4j
sudo service neo4j stop

# then, let's rename that default `graph.db` neo4j database
# that we created when we started neo4j up for the first time
sudo mv /var/lib/neo4j/data/databases/graph.db /var/lib/neo4j/data/databases/graph.db.bak

# manually import graph data into neo4j on the server
sudo neo4j-import --into /var/lib/neo4j/data/databases/graph.db/ --nodes /home/ubuntu/workspace/blockbuilder-graph-search-index/data/csv-graphs-for-neo4j/readme-links-blocks.csv --relationships /home/ubuntu/workspace/blockbuilder-graph-search-index/data/csv-graphs-for-neo4j/readme-links-relationships.csv

# if this succeeds, you should see something like this:
#
# Done in 40ms

# IMPORT DONE in 3s 221ms.
# Imported:
#   6443 nodes
#   8848 relationships
#   32161 properties
# Peak memory usage: 516.30 MB

# it's worth noting that an alternate approach
# is to copy over a neo4j database that 
# we create on our local machine

#
#
# setup the graph visualization frontend
#
#

#
# first, let's install some dependencies for the frontend
#

#
# install nodejs on ubuntu
# https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04
#

# to get a recent nodejs, we'll follow these steps:
sudo apt-get update
sudo apt-get install build-essential libssl-dev
curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh -o install_nvm.sh

# inspect the script with the text editor nano
nano install_nvm.sh

# run install script with bash
bash install_nvm.sh
export NVM_DIR="$HOME/.nvm"
source ~/.profile

# To find out the versions of Node.js that are available for installation, you can type:
bash
nvm ls-remote
nvm install 9.4.0
zsh
node -v
# v9.4.0

# install webserver `serve`
npm i -g serve
# /home/ubuntu/.nvm/versions/node/v9.4.0/bin/serve -> /home/ubuntu/.nvm/versions/node/v9.4.0/lib/node_modules/serve/bin/serve.js
# + serve@6.4.8
# added 159 packages in 4.964s

# start the webserver for our blockbuilder graph search
# graph visualization frontend
cd /home/ubuntu/workspace/blockbuilder-graph-search-ui/
serve -s build -p 8080 # -s single page, -p port 8080
 
# visit http://138.197.194.92:8080/
# in the browser and admire your handiwork 🎉

