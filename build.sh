#!/bin/bash
display_usage() {
	echo "$0 version_for_frontend version_for_backend"
	echo -e "\nUsage: $0 [arguments] \n"
    }
# if less than two arguments supplied, display usage
	if [  $# -le 1 ]
	then
		display_usage
		exit 1
	fi

app_to_release="$1"
ver="$2"

if [ "$app_to_release" = "family-tree-frontend" ]; then 
    ftfe_release=$ver
elif [ "$app_to_release" = "family-tree-backend" ]; then 
    ftbe_release=$ver
fi


# If no version specified read from last
if [ -z "$ftbe_release" ]; then
    ftbe_release="$(head -n1 ftbe.rel.ver)"
else
    echo "$ftbe_release" > ftbe.rel.ver
fi

# If no version specified read from last
if [ -z "$ftfe_release" ]; then
    ftbe_release="$(head -n1 ftfe.rel.ver)"
else
    echo "$ftfe_release" > ftfe.rel.ver
fi

docker-compose build --no-cache --build-arg FTFE_RELEASE="$ftfe_release" --build-arg FTBE_RELEASE="$ftbe_release"
docker-compose up -d
sleep 60
cd neo4j
./seed_database.sh
