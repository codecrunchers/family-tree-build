#!/bin/bash
container=$(docker  ps | grep -o "family-tree-build_neo4j_[0-9]")
cat cypher/family.cypher | sudo  docker exec --interactive  "$container"  cypher-shell -u neo4j -p password


