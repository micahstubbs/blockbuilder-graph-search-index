const fs = require('fs');
const csvWriter = require('csv-write-stream');

const inputPath = 'data/source-data';
const inputFile = `${inputPath}/blocks-colors.json`;
const inputData = JSON.parse(fs.readFileSync(inputFile, 'utf-8'));

const outputDir = 'data/csv-graphs-for-neo4j';
let outputData = [];

const colorsHash = {};
inputData.forEach(block => {
  const colorsObject = block.colors;
  const colorsArray = Object.keys(colorsObject);
  colorsArray.forEach(color => {
    colorsHash[color] = true;
  });
});

outputData = Object.keys(colorsHash).map(d => {
  const nodeObject = {};
  nodeObject['color:ID'] = d;
  return nodeObject;
});

// write a csv file
outputFile = `${outputDir}/colors.csv`;
writer = csvWriter();
writer.pipe(fs.createWriteStream(outputFile));
outputData.forEach(d => {
  writer.write(d);
});
writer.end();
