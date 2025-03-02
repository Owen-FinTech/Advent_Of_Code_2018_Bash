#!/bin/bash

result=0
duplicate="false"
declare -A arr  # Declare an associative array
arr[$result]=1

while [[ "$duplicate" == "false" ]]; do
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Perform arithmetic operation directly
        if [[ ${line:0:1} == '+' ]]; then
            result=$((result + ${line:1}))
        else
            result=$((result - ${line:1}))
        fi

        # Check for duplicate using associative array
        if [[ -n "${arr[$result]}" ]]; then
            duplicate="true"
            break 2
        else
            arr[$result]=1
        fi
    done < "input.txt"
done

echo $result