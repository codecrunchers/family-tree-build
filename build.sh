#!/bin/bash
display_usage() {
	echo "$0 version_for_frontend version_for_backend"
	echo -e "\nUsage: $0 [arguments] \n"
	}
# if less than two arguments supplied, display usage
	if [  $# -le 3 ]
	then
		display_usage
		exit 1
	fi

ftfe_build="$1"
ftbe_release="$2"

#tmp_dir=$(mktemp -d -t ft-XXXXXXX)
#echo "Using Dir $tmp_dir"
#cd $tmp_dir
#curl -L https://github.com/codecrunchers/family-tree-build/archive/master.zip --output ft.zip
#unzip ft.zip
#cd family-tree-build-master/
docker-compose build --build-arg FTFE_RELEASE="$ftfe_build" --build-arg FTBE_RELEASE="$ftbe_release"
docker-compose up -d
sleep 60
cd neo4j
./seed_database.sh




