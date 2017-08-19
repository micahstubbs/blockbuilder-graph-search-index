const fs = require('fs');
const csvWriter = require('csv-write-stream');

const inputDir = 'data/source-graphs';
const inputFile = `${inputDir}/readme-blocks-graph.json`;
const outputDir = 'data/csv-graphs-for-neo4j';

const inputData = JSON.parse(fs.readFileSync(inputFile, 'utf-8'));
const usersHash = {};

inputData.graph.nodes.forEach(inputNode => {
  usersHash[inputNode.user] = true;
});

// write a csv file
const usersData = Object.keys(usersHash).map(d => ({ user: d }));
outputFile = `${outputDir}/users.csv`;
writer = csvWriter();
writer.pipe(fs.createWriteStream(outputFile));
usersData.forEach(d => {
  writer.write(d);
});
writer.end();