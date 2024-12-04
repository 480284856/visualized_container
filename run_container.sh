#!/bin/bash

# Default values
BASE_IMAGE="ubuntu:20.04"
IMAGE_NAME="visualised_image"
CONTAINER_NAME="visualised_container"

# Parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --base-image)
            BASE_IMAGE="$2"
            shift 2
            ;;
        --image-name)
            IMAGE_NAME="$2"
            shift 2
            ;;
        --container-name)
            CONTAINER_NAME="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Build image
docker build -t $IMAGE_NAME --build-arg BASE_IMAGE=$BASE_IMAGE .

# Run container and map ports
docker run -d -p 6080:6080 --name $CONTAINER_NAME $IMAGE_NAME

# Tell the user
echo "Container running at http://localhost:6080"
echo "Password: 123123"