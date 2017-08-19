const fs = require('fs');
const csvWriter = require('csv-write-stream');

const inputPath = 'data/source-graphs';
const inputFile = `${inputPath}/blocks-api.json`;
const inputData = JSON.parse(fs.readFileSync(inputFile, 'utf-8'));

const outputDir = 'data/csv-graphs-for-neo4j'
const outputData = [];


inputData.forEach(block => {
  const functionsObject = block.api;
  const functionsArray = Object.keys(functionsObject);
  functionsArray.forEach(d3Function => {
    const linkObject = {};
    linkObject[':START_ID'] = replaceNull(block.id);
    linkObject[':END_ID'] = replaceNull(d3Function);
    linkObject[':TYPE'] = 'CALLS';
    linkObject['count:int'] = functionsObject[d3Function];
    if (
      linkObject[':START_ID'].length > 0 &&
      linkObject[':END_ID'].length > 0
    ) {
      outputData.push(linkObject);
    }
  });
}
});

// write a csv file
outputFile = `${outputDir}/block-calls-function-relationships.csv`;
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