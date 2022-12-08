#! /bin/bash

# parse command line arguments
FORCE_UPDATE=false
SKIP_DOCKER=false
while true; do
  case "$1" in
    -f | --force-update ) FORCE_UPDATE=true; shift ;;
    -s | --skip-docker ) SKIP_DOCKER=true; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done


# Start docker AND mysqldk container
if [ "$SKIP_DOCKER" != "true" ]; then 
	sudo service docker start
	sudo docker start mysqldk
fi

# Navigate to application directory
cd ~/local-repos/BHT-EMR-API/

if $FORCE_UPDATE; then
	# pull latest updates
	git pull

	# update metadata
	./bin/update_art_metadata.sh development
fi

# start development server
rails s -b 0.0.0.0
