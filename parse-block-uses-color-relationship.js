const fs = require('fs');
const csvWriter = require('csv-write-stream');

const inputPath = 'data/source-data';
const inputFile = `${inputPath}/blocks-colors.json`;
const inputData = JSON.parse(fs.readFileSync(inputFile, 'utf-8'));

const outputDir = 'data/csv-graphs-for-neo4j';
const outputData = [];

inputData.forEach(block => {
  const colorsObject = block.colors;
  const colorsArray = Object.keys(colorsObject);
  colorsArray.forEach(color => {
    const linkObject = {};
    linkObject[':START_ID'] = replaceNull(block.id);
    linkObject[':END_ID'] = replaceNull(color);
    linkObject[':TYPE'] = 'USES';
    linkObject['count:int'] = colorsObject[color];
    if (
      linkObject[':START_ID'].length > 0 &&
      linkObject[':END_ID'].length > 0
    ) {
      outputData.push(linkObject);
    }
  });
});

// write a csv file
outputFile = `${outputDir}/block-uses-color-relationships.csv`;
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
