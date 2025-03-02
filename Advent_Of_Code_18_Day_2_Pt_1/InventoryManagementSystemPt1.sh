#!/bin/bash

twoCount=0
threeCount=0

while IFS= read -r line || [[ -n "$line" ]]; do
    declare -A arr  # Declare an associative array

    # Count the frequency of each letter
    for (( i=0; i<${#line}; i++ )); do 
        lett=${line:i:1}
        if [[ -n "${arr[$lett]}" ]]; then
            arr[$lett]=$((arr[$lett] + 1))
        else
            arr[$lett]=1
        fi
    done

    # Check for counts of 2 and 3
    foundTwo=0
    foundThree=0
    for count in "${arr[@]}"; do
        if [[ "$count" -eq 2 ]]; then
            foundTwo=1
        elif [[ "$count" -eq 3 ]]; then
            foundThree=1
        fi
    done

    if [[ "$foundTwo" -eq 1 ]]; then
        twoCount=$((twoCount + 1))
    fi

    if [[ "$foundThree" -eq 1 ]]; then
        threeCount=$((threeCount + 1))
    fi

    unset arr
done < "input.txt"

echo "$((twoCount * threeCount))"
