const fs = require('fs');
const csvWriter = require('csv-write-stream');

const inputDir = 'data/source-graphs';
const inputFile = `${inputDir}/readme-blocks-graph.json`;
const outputDir = 'data/csv-graphs-for-neo4j';

const inputData = JSON.parse(fs.readFileSync(inputFile, 'utf-8'));
const outputData = [];

inputData.graph.nodes.forEach(inputNode => {
  const linkObject = {};
  linkObject[':START_ID(user)'] = replaceNull(inputNode.user);
  linkObject[':END_ID(gistId)'] = replaceNull(inputNode.id);
  linkObject[':TYPE'] = 'BUILT';

  if (linkObject[':START_ID(user)'].length > 0 && linkObject[':END_ID(gistId)'].length > 0) {
    outputData.push(linkObject);
  }
});

// write a csv file
outputFile = `${outputDir}/user-built-block-relationships.csv`;
writer = csvWriter();
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
