# Stop Docker containers of the dhimmel/hetionet image
docker rm $(docker stop $(docker ps --all --quiet --filter ancestor=micahstubbs/blockbuilder-graph-search --format="{{.ID}}"))
