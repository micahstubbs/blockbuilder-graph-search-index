const fs = require('fs');
const csvWriter = require('csv-write-stream');

const inputDir = 'data/source-data';
const outputDir = 'data/csv-graphs-for-neo4j';

// load data synchronously for now
// slower than async, but easier to reason about
const readmeLinksInputFile = `${inputDir}/readme-blocks-graph.json`;
const readmeLinksInputData = JSON.parse(
  fs.readFileSync(readmeLinksInputFile, 'utf-8')
);

// const functionsInputFile = `${inputDir}/blocks-api.json`;
// const functionsInputData = JSON.parse(
//   fs.readFileSync(functionsInputFile, 'utf-8')
// );
// const formattedFunctionsInputData = functionsInputData.map(block => {
//   const nodeObject = {};
//   nodeObject.id = block.id;
//   nodeObject.user = block.userId;
//   nodeObject.createdAt = block.created_at;
//   nodeObject.updatedAt = block.updated_at;
//   return nodeObject;
// })

// const inputDatasets = [readmeLinksInputData, functionsInputData];
// const inputData = [].concat.apply([], inputDatasets);

let outputData = [];
const nodeHash = {};

//
// translate the node data from the existing format
// to a format closer to what neo4j expects
// following this guid https://neo4j.com/docs/operations-manual/3.2/tutorial/import-tool/
//
inputData.forEach(inputNode => {
  const nodeObject = {};
  // use neo4j conventions for keys
  nodeObject['gistId:ID'] = inputNode.id;
  // model users as nodes too later?
  nodeObject.user = replaceNull(inputNode.user);
  nodeObject.createdAt = replaceNull(inputNode.createdAt);
  nodeObject.updatedAt = replaceNull(inputNode.updatedAt);
  nodeObject.description = replaceNull(inputNode.description);
  nodeObject[':LABEL'] = ''; // add tags here later
  nodeHash[inputNode.id] = nodeObject;
});

outputData = Object.keys(nodeHash).map(key => nodeHash[key]);

// write a csv file
let outputFile = `${outputDir}/blocks.csv`;
let writer = csvWriter();
writer.pipe(fs.createWriteStream(outputFile));
outputData.forEach(d => {
  writer.write(d);
});
writer.end();

function replaceNull(value) {
  if (value === null) {
    return 'null';
  } else if (typeof value === 'undefined') {
    return 'undefined';
  }
  return value;
}
