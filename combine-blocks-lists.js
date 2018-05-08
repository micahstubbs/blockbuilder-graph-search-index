const fs = require('fs')
// const csv = require('csv')
const parse = require('csv-parse/lib/sync')

// read in blocks data we want to combine
const blockbuilderSearchBlocksFile = 'data/csv-graphs-for-neo4j/blocks.csv'
const readmeVisBlocksFile = 'data/csv-graphs-for-neo4j/readme-links-blocks.csv'

// read in the blocks data and parse it as csv
const blockbuilderSearchBlocksData = parse(
  fs.readFileSync(blockbuilderSearchBlocksFile, 'utf-8')
)
const readmeVisBlocksData = parse(fs.readFileSync(readmeVisBlocksFile), 'utf-8')

console.log('blockbuilderSearchBlocksData[1]', blockbuilderSearchBlocksData[1])
console.log('readmeVisBlocksData[1]', readmeVisBlocksData[1])
