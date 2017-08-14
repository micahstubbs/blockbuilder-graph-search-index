# ssh into digitalocean droplet
ssh root@138.197.194.92

# setup a non-root user
https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04

# generally follow this guide
https://think-lab.github.io/d/216/#1

# install zsh on the ubuntu server
# https://gist.github.com/tsabat/1498393

# install neo4j and depedencies
# http://www.exegetic.biz/blog/2016/09/installing-neo4j-ubuntu-16-04/

# use this modifed command
wget --no-check-certificate -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add -

# then see if neo4j is running
# 138.197.194.92:7474

# it won't work just yet
# I see an net::ERR_CONNECTION_REFUSED message

# setup let's encrypt cert
https://github.com/dhimmel/hetionet/blob/1ee2479b2d98de331dedce600ce08fca43d3395b/hetnet/neo4j/docker/ssl/install.sh

# install docker on the server
https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository

# list all local docker containers
docker ps -a

#
# now setup some front-end things
#

# configure firewall
https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands

# install nginx to route base IP address to a port we want to show,
# like for example port 8080 
https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-16-04

sudo ln -s /etc/nginx/sites-available/graphdata /etc/nginx/sites-enabled/graphdata
sudo service nginx configtest
sudo service nginx restart

# configure a reverse proxy
# so that the domain points where I want it to
https://www.digitalocean.com/community/questions/how-do-i-point-my-custom-domain-to-my-ip-port-41-111-20-36-8080

# install nodejs on ubuntu
https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04
 
# symlink nodejs path
# https://github.com/nodejs/node-v0.x-archive/issues/3911
ln -s /usr/bin/nodejs /usr/bin/node

# install pm2 to serve our front-end
# https://www.npmjs.com/package/pm2
npm install pm2 -g

# go to the directory with the front-end
cd /root/workspace/bbgs-ui-prototypes

# start server with pm2
pm2 start /usr/local/lib/node_modules/http-server/bin/http-server . --name blockbuilder-graph-search -- -p 8080 -d false

# start web server with http-server in background mode
nohup http-server -p 8080 &

# see open ports on server
netstat -ntlp | grep LISTEN

# open up the ports for neo4j
sudo iptables -I INPUT -p tcp -s 0.0.0.0/0 --dport 7687 -j ACCEPT
sudo iptables -I INPUT -p tcp -s 0.0.0.0/0 --dport 7474 -j ACCEPT
sudo iptables -I INPUT -p tcp -s 0.0.0.0/0 --dport 7473 -j ACCEPT

# an alternate way to to open up ports for neo4j
sudo ufw allow 7687
sudo ufw allow 7474
sudo ufw allow 7473

# copy configuration up to server
scp neo4j.conf root@138.197.194.92:/etc/neo4j/

# command to manually import graph on the server
neo4j-import --into /var/lib/neo4j/data/databases/graph.db/ --nodes /root/workspace/blockbuilder-graph-search-index/data/csv-graphs-for-neo4j/readme-links-blocks.csv --relationships /root/workspace/blockbuilder-graph-search-index/data/csv-graphs-for-neo4j/readme-links-relationships.csv
 


