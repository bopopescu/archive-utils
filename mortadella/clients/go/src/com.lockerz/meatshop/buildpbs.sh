#!/bin/bash

rm -rf pbs
mkdir pbs
protoc --go_out=/tmp protobuf/*.proto
mv /tmp/protobuf/* pbs
