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