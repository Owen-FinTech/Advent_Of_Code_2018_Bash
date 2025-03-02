#!/bin/bash

declare -a arr

while IFS= read -r line || [[ -n "$line" ]]; do
    arr+=("$line")    
done < "input.txt"

for (( i=0; i<${#arr[@]}-1; i++ )); do
    for (( j=i+1; j<${#arr[@]}; j++ )); do
        matchCount=0
        boxID=""

        for (( k=0; k<${#arr[i]}; k++ )); do
            if [[ "${arr[i]:k:1}" == "${arr[j]:k:1}" ]]; then
                boxID+="${arr[i]:k:1}"
                matchCount=$((matchCount + 1))
            fi
        done

        if [[ "$matchCount" -eq $((${#arr[i]} - 1)) ]]; then
            echo "$boxID"
            break 2
        fi
    done
done