# parse nodes
node parse-blocks.js
node parse-users.js
node parse-functions.js
node parse-colors.js

# parse relationships
node parse-user-built-block-relationships.js
node parse-block-calls-function-relationships.js
node parse-block-uses-color-relationship.js

# parse both nodes and relationships
convert-json-to-csv-for-neo4j-readme-links.js