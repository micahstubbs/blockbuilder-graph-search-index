cd ~/

# print a separator line
printf '%79s\n' | tr ' ' '#'

# output date
date --iso-8601=seconds --universal

# stop docker container
sh stop-docker.sh

# renew certificates
letsencrypt renew --non-interactive
cp /etc/letsencrypt/live/d3.graphdata.org/fullchain.pem ~/ssl/d3.cert
cp /etc/letsencrypt/live/d3.graphdata.org/privkey.pem ~/ssl/d3.key

# start docker
sh run-docker.sh
