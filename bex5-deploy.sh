#/bin/bash

curl -X POST http://192.168.1.1:8080/v2/apps -d@bex5.json -H "Content-type: application/json"
