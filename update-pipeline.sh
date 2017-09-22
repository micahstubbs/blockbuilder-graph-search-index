# following the guide here
# https://github.com/enjalot/blockbuilder-search-index
#
# stats from an update run on 20170921
#
# this will be fast
coffee combine-users.coffee
# 2672 users total
#
# this will take a few minutes
coffee validate-users.coffee
# 2301 have at least 1 gist
# 26 new users
#
coffee gist-meta.coffee data/latest.json 2016-10-14T00:00:00Z
# remaining rate limit of ~2600 API calls ran out at user 1538 `meveritt`
# observation: github API rate limit is shared between 
# the `validate-users` script and the `gist-meta` script
# back up usables to `usables.csv.bak`
# remove all users prior to `meveritt` for second run
#
# second run, an ~hour later
coffee gist-meta.coffee data/latest.json 2016-10-14T00:00:00Z
# uh, did I just overwrite data/latest.json from the first run?
# yep, looks like I did.
# ok round three with the first part of the alphabet again
# retrieve from our `usables.csv.bak`
# all users prior to `meveritt` for third run
# third run
coffee gist-meta.coffee data/latest.json 2016-10-14T00:00:00Z
# ok that succeeded
# now 2735 + 6389 = 9124 new blocks since 2016-10-14
# now let's clone all the gists we found in runs 2 and 3
# these will both take tens of minutes
coffee gist-cloner.coffee data/latest-run-2.json
coffee gist-cloner.coffee data/latest-run-3.json
# now lets parse out the metadata
coffee parse.coffee
# skipped 0 missing files
# wrote 10446 API blocks
# wrote 11523 Color blocks
# wrote 98585 Files blocks
# wrote 25277 total blocks
#
# now let's update the README graph
# https://github.com/micahstubbs/readme-vis/tree/master/data/scripts
cp -r /Users/m/workspace/blockbuilder-search-index/data/parsed/ /Users/m/workspace/readme-vis/data/gist-metadata/input/
cd /Users/m/workspace/readme-vis/data/scripts
# now run some node scripts to generate the graph
node 01-gists-with-readme.js
# 18029 README.md files in the d3 gists corpus
node 02-gists-with-readme-with-blocks-link.js
# 573 gists with unknown users
# 724 gists with missing files or folders
# 18029 README.md files in the d3 gists corpus
# of those README.md files
# 8600 contain links to bl.ocks.org
node 03a-generate-graph.js
# 6443 nodes
# 20705 links
# in the D3 README graph
#
# now let's copy the readme-graph to the blockbuilder-graph-search-index project
cp /Users/m/workspace/readme-vis/data/gist-metadata/output/readme-blocks-graph.json /Users/m/workspace/blockbuilder-graph-search-index/data/source-data
cd /Users/m/workspace/blockbuilder-graph-search-index
sh update-source-data.sh
sh parse.sh
sh load-csv-graph-into-neo4j.sh
# IMPORT DONE in 4s 460ms.
# Imported:
#   40960 nodes
#   257253 relationships
#   363743 properties
# Peak memory usage: 524.42 MB

