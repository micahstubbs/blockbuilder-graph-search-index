const fs = require('fs');
const csvWriter = require('csv-write-stream');

const inputPath = 'data/source-graphs';
const inputFile = `${inputPath}/blocks-api.json`;
const inputData = JSON.parse(fs.readFileSync(inputFile, 'utf-8'));

const outputDir = 'data/csv-graphs-for-neo4j';
let outputData = [];

const functionsHash = {};
inputData.forEach(block => {
  const functionsObject = block.api;
  const functionsArray = Object.keys(functionsObject);
  functionsArray.forEach(d3Function => {
    functionsHash[d3Function] = true;
  });
});

outputData = Object.keys(functionsHash).map(d => {
  const nodeObject = {};
  nodeObject['function:ID'] = d;
  return nodeObject;
});

// write a csv file
outputFile = `${outputDir}/functions.csv`;
writer = csvWriter();
writer.pipe(fs.createWriteStream(outputFile));
outputData.forEach(d => {
  writer.write(d);
});
writer.end();
