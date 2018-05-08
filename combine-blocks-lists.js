const fs = require('fs')
// const csv = require('csv')
const parse = require('csv-parse/lib/sync')
const R = require('ramda')

// read in blocks data we want to combine
const blockbuilderSearchBlocksFile = 'data/csv-graphs-for-neo4j/blocks.csv'
const readmeVisBlocksFile = 'data/csv-graphs-for-neo4j/readme-links-blocks.csv'

// read in the blocks data and parse it as csv
const blockbuilderSearchBlocksData = parse(
  fs.readFileSync(blockbuilderSearchBlocksFile, 'utf-8'),
  { columns: true }
)
const readmeVisBlocksData = parse(
  fs.readFileSync(readmeVisBlocksFile, 'utf-8'),
  { columns: true }
)
console.log(
  `${
    blockbuilderSearchBlocksData.length
  } unique blocks in list from blockbuilder-search-index`
)
console.log(
  `${readmeVisBlocksData.length} unique blocks in list from readme-vis`
)

// console.log('blockbuilderSearchBlocksData[1]', blockbuilderSearchBlocksData[1])
// console.log('readmeVisBlocksData[1]', readmeVisBlocksData[1])

// list blockbuilder search datasource second
// so that it overwrites any conflicting properties that may exist
// for blocks that are present in both sets
const datasets = [readmeVisBlocksData, blockbuilderSearchBlocksData]
const blocksHash = {}

datasets.forEach(ds => {
  ds.forEach(block => {
    const key = block['gistId:ID']
    blocksHash[key] = block
  })
})

// an array of all the blocks with unique gistIds
const outputData = R.values(blocksHash)
console.log(`${outputData.length} unique blocks in combined list`)
