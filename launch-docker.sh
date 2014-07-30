#!/bin/bash

PWD=$(cd $(dirname $0); pwd)

docker run -ti -p 20022:22 -p 28977:8977 test-supervisord
