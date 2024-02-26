#!/bin/bash
FILE="${1##*/}"
docker exec compiler p4c-bm2-ss "$1" -o "Build/${FILE%%.*}.json"
