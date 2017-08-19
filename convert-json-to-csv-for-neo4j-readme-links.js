const fs = require('fs');
const csvWriter = require('csv-write-stream');

const inputDir = 'data/source-graphs';
const inputFile = `${inputDir}/readme-blocks-graph.json`;
const outputDir = 'data/csv-graphs-for-neo4j';
const metricsOutputDir = 'data/graph-metrics';

const inputData = JSON.parse(fs.readFileSync(inputFile, 'utf-8'));

const outputData = {
  graph: {
    nodes: [],
    links: []
  }
};

function replaceNull(value) {
  if (value === null) {
    return 'null';
  } else if (typeof value === 'undefined') {
    return 'undefined';
  }
  return value;
}

// prune links that refer to missing nodes
const missingNodes = [];
const nodeList = inputData.graph.nodes.map(d => d.id);
// console.log('nodeList', nodeList);

//
// translate the node data from the existing format
// to a format closer to what neo4j expects
// following this guid https://neo4j.com/docs/operations-manual/3.2/tutorial/import-tool/
//
inputData.graph.nodes.forEach(inputNode => {
  const nodeObject = {};
  // use neo4j conventions for keys
  nodeObject['gistId:ID'] = inputNode.id;
  // model users as nodes too later?
  nodeObject.user = replaceNull(inputNode.user);
  nodeObject.createdAt = replaceNull(inputNode.createdAt);
  nodeObject.updatedAt = replaceNull(inputNode.updatedAt);
  nodeObject.description = replaceNull(inputNode.description);
  nodeObject[':LABEL'] = ''; // add tags here later
  outputData.graph.nodes.push(nodeObject);
});

// write a csv file
let outputFile = `${outputDir}/readme-links-blocks.csv`;
let writer = csvWriter();
writer.pipe(fs.createWriteStream(outputFile));
outputData.graph.nodes.forEach(d => {
  writer.write(d);
});
writer.end();

// write a csv file
const nodesObjs = nodeList.map(d => ({
  id: replaceNull(d)
}));
outputFile = `${metricsOutputDir}/readme-links-nodelist.csv`;
writer = csvWriter();
writer.pipe(fs.createWriteStream(outputFile));
nodesObjs.forEach(d => {
  writer.write(d);
});
writer.end();

//
// translate the links data from the existing format
// to a format closer to what neo4j expects
//
inputData.graph.links.forEach((inputLink, i) => {
  // filter out missing nodes
  if (nodeList.indexOf(inputLink.source) === -1) {
    missingNodes.push(inputLink.source);
  } else if (nodeList.indexOf(inputLink.target) === -1) {
    missingNodes.push(inputLink.target);
  } else {
    const linkObject = {};
    linkObject[':START_ID'] = replaceNull(inputLink.source);
    linkObject[':END_ID'] = replaceNull(inputLink.target);
    linkObject[':TYPE'] = 'LINKS_TO';

    // add this check to avoid links with blank strings as source or target
    // which in turn avoids the
    // ...is missing END_ID field
    // neo4j import error
    if (
      linkObject[':START_ID'].length > 0 &&
      linkObject[':END_ID'].length > 0
    ) {
      outputData.graph.links.push(linkObject);
    }
  }
});

// write a csv file
outputFile = `${outputDir}/readme-links-relationships.csv`;
writer = csvWriter();
writer.pipe(fs.createWriteStream(outputFile));
outputData.graph.links.forEach(d => {
  writer.write(d);
});
writer.end();

// write a csv file
const missingNodesObjs = missingNodes.map(d => ({
  id: replaceNull(d)
}));
// console.log('missingNodes', missingNodes);
// console.log('missingNodesObjs', missingNodesObjs);
outputFile = `${metricsOutputDir}/readme-links-missing-nodes.csv`;
writer = csvWriter();
writer.pipe(fs.createWriteStream(outputFile));
missingNodesObjs.forEach(d => {
  writer.write(d);
});
writer.end();
