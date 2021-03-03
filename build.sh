#!/bin/bash
build="$1"
tmp_dir=$(mktemp -d -t ft-XXXXXXX)
echo "Using Dir $tmp_dir"
cd $tmp_dir
curl -L https://github.com/codecrunchers/family-tree-build/archive/master.zip --output ft.zip
unzip ft.zip
cd family-tree-build-master/
docker-compose build --build-arg RELEASE="$build"
docker-compose up -d
sleep 60
cd neo4j
./seed_database.sh




