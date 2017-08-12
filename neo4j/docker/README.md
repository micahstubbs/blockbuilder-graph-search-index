# Docker to host an alpha build of blockbuilder graph search for d3 example graph in Neo4j at d3.graphdata.org

This Docker image hosts the d3 example graph in a publicly accessible Neo4j instance. The image is on [Docker hub as `micahstubbs/blockbuilder-graph-search`](https://hub.docker.com/r/micahstubbs/blockbuilder-graph-search/) and the live container is available at https://d3.graphdata.org

The image is highly specialized for our application and setup. For example, it includes a website-specific web analytics javascript. You can learn more our [customizations here](https://thinklab.com/discussion/hosting-hetionet-in-the-cloud-creating-a-public-neo4j-instance/216)

The contents of this repository are mostly included in the Docker image. However, the [`host`](host) contains files that are meant for the cloud host running the Docker virtual machine.

## Building the docker

Build the image using the following command:

```sh
TAG="micahstubbs/blockbuilder-graph-search:blockbuilder-graph-search-v1.0_neo4j-3.1.4"
docker build --tag micahstubbs/blockbuilder-graph-search:latest --tag $TAG --file Dockerfile .
```

When the image is ready, it's uploaded to Docker hub using `docker push micahstubbs/blockbuilder-graph-search`.

## Running the docker

To run the image on a local system, (development or local usage) run the following:

```sh
docker run \
  --name=blockbuilder-graph-search-container \
  --publish=7474:7474 \
  --publish=7687:7687 \
  --volume=$HOME/neo4j/blockbuilder-graph-search-data:/data \
  --volume=$HOME/neo4j/blockbuilder-graph-search-data-logs:/logs \
  micahstubbs/blockbuilder-graph-search
```

## Deploying the docker

From the cloud host, first pull the docker `docker pull micahstubbs/blockbuilder-graph-search` and then start the docker `sh ~/run-docker.sh`. `run-docker.sh` should be copied from [`host/run-docker.sh`](host/run-docker.sh) in this repository into $HOME on the cloud host.

a fork of [dhimmel/hetionet](https://hub.docker.com/r/dhimmel/hetionet/) from [@dhimmel](https://twitter.com/dhimmel)
