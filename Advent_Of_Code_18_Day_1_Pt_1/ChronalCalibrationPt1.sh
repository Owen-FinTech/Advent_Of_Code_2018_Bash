#!/bin/bash

result=0

for line in $(cat "input.txt"); do
    lineLen=${#line}
    if [[ ${line:0:1} == '+' ]]; then
        result=$((result + ${line:1:lineLen - 1}))
    else
        result=$((result - ${line:1:lineLen - 1}))
    fi
done

echo $result