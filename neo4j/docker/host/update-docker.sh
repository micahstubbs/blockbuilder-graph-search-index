# Update the Docker image, restarts the container

cd ~/

# stop docker container
sh stop-docker.sh

# Pull the latest docker image
docker pull micahstubbs/blockbuilder-graph-search

# start docker
sh run-docker.sh
