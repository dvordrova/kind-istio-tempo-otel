#!/bin/bash

in_path=$1

if [ -d $in_path ]; then
    echo "Directory $in_path exists"
else
    echo "Directory $in_path does not exist"
fi

for file in $in_path/*; do
    if [ -f $file ]; then
        echo "Apply kubectl patch: $file"
        kubectl apply -f $file
    fi
done
