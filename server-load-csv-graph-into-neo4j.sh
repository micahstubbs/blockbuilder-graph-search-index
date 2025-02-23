# store some paths as variables
GRAPH_DATABASE_DIR=/var/lib/neo4j/data/databases/graph.db/
CSV_DATA_DIR=/root/workspace/blockbuilder-graph-search-index/data/csv-graphs-for-neo4j/

# build up paths to input csv files

# nodes source data
USERS=$CSV_DATA_DIR/users.csv
FUNCTIONS=$CSV_DATA_DIR/functions.csv
BLOCKS=$CSV_DATA_DIR/blocks.csv
COLORS=$CSV_DATA_DIR/colors.csv

# relationships source data
USERS_BUILT_BLOCKS_RELATIONSHIPS=$CSV_DATA_DIR/user-built-block-relationships.csv
BLOCK_CALLS_FUNCTION_RELATIONSHIPS=$CSV_DATA_DIR/block-calls-function-relationships.csv
README_LINKS_RELATIONSHIPS=$CSV_DATA_DIR/readme-links-relationships.csv
BLOCK_USES_COLOR_RELATIONSHIPS=$CSV_DATA_DIR/block-uses-color-relationships.csv

neo4j-import --into $GRAPH_DATABASE_DIR --nodes $BLOCKS --nodes $USERS --nodes $FUNCTIONS --nodes $COLORS --relationships $README_LINKS_RELATIONSHIPS --relationships $USERS_BUILT_BLOCKS_RELATIONSHIPS --relationships $BLOCK_CALLS_FUNCTION_RELATIONSHIPS --relationships $BLOCK_USES_COLOR_RELATIONSHIPS --multiline-fields=true