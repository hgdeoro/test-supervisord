#!/bin/bash

PWD=$(cd $(dirname $0); pwd)
cd $PWD

docker build -t test-supervisord .
