const fs = require('fs');
const csvWriter = require('csv-write-stream');

const inputDir = 'data/source-data';
const inputFile = `${inputDir}/blocks-min.json`;
const outputDir = 'data/csv-graphs-for-neo4j';

const inputData = JSON.parse(fs.readFileSync(inputFile, 'utf-8'));
const usersHash = {};

inputData.forEach(inputNode => {
  usersHash[inputNode.userId] = true;
});

// write a csv file
const usersData = Object.keys(usersHash).map(d => {
  const nodeObject = {};
  nodeObject['user:ID'] = d;
  return nodeObject;
});
outputFile = `${outputDir}/users.csv`;
writer = csvWriter();
writer.pipe(fs.createWriteStream(outputFile));
usersData.forEach(d => {
  writer.write(d);
});
writer.end();
