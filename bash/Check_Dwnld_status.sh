#!/bin/bash

for item in $(cat ${1}); do
echo ${item} \
$(grep -m 1 "Files to download in this request:" ${item}/${item}.log | awk 'NF>1{print $NF}') \
$(grep -P "^Completed download:" ${item}/${item}.log | grep "true" | wc -l ) 
done 
