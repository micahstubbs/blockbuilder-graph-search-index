# store some paths as variable
NEO4J_HOME=/Users/m/Documents/Neo4j
GRAPH_DATABASE_DIR=data/databases/blockbuilder-graph-search.db
CSV_DATA_DIR=/Users/m/workspace/blockbuilder-graph-search-index/data/csv-graphs-for-neo4j

# build up paths to input csv files
USERS=$CSV_DATA_DIR/users.csv
USERS_BUILT_BLOCKS_RELATIONSHIPS=$CSV_DATA_DIR/user-built-block-relationships.csv
README_LINKS_BLOCKS=$CSV_DATA_DIR/readme-links-blocks.csv
README_LINKS_RELATIONSHIPS=$CSV_DATA_DIR/readme-links-relationships.csv


cd $NEO4J_HOME
./bin/neo4j-import --into $GRAPH_DATABASE_DIR --nodes $README_LINKS_BLOCKS --nodes $USERS --relationships $README_LINKS_RELATIONSHIPS --relationships $USERS_BUILT_BLOCKS_RELATIONSHIPS --multiline-fields=true