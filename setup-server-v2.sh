# a script to setup the new gcp server
# perhaps a pattern for a container in the future


# name
# blockbuilder-graph-search-1
# internal IP 10.138.0.2
# external IP 35.203.147.195

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
# install some nice things
# to make this server feel like home
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
#
#

# now, let's clone some 
# blockbuilder-graph-search project repos
cd workspace
git clone git@github.com:micahstubbs/blockbuilder-graph-search-index.git
git clone git@github.com:micahstubbs/blockbuilder-graph-search-ui.git

#
# install neo4j and depedencies
# follow this guide
# http://www.exegetic.biz/blog/2016/09/installing-neo4j-ubuntu-16-04/
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

# likewise, we can restart he neo4j server with this command
sudo service neo4j start

# let's then see if neo4j is running
# http://35.203.147.195:7474/

# it won't work just yet
# I see an ERR_CONNECTION_TIMED_OUT message in the browser

# ok, let's open up some ports for neo4j
# in the firewall 
# an alternate way to to open up ports for neo4j
sudo ufw allow 7687
sudo ufw allow 7474
sudo ufw allow 7473

#
#
#
#
#


