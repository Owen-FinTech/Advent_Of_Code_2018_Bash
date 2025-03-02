#!/bin/bash

maxWidth=0
maxHeight=0
declare -a inputArr

while IFS= read -r line || [[ -n "$line" ]]; do
    startCol=""
    startRow=""
    width=""
    height=""
    spaceCount=0
    first="true"
    for (( i=0; i<${#line}; i++ )); do
        if [[ "${line:i:1}" == ' ' ]]; then
            spaceCount=$((spaceCount + 1))
        elif [[ "$spaceCount" -eq 2 ]] && [[ "$first" == "true" ]]; then
            if [[ "${line:i:1}" == ',' ]]; then
                first="false"
            else
                startCol+="${line:i:1}"
            fi
        elif [[ "$spaceCount" -eq 2 ]] && [[ "$first" == "false" ]]; then
            if [[ "${line:i:1}" == ':' ]]; then
                first="true"
            else
                startRow+="${line:i:1}"
            fi
        elif [[ "$spaceCount" -eq 3 ]] && [[ "$first" == "true" ]]; then
            if [[ "${line:i:1}" == 'x' ]]; then
                first="false"
            else
                width+="${line:i:1}"
            fi
        elif [[ "$spaceCount" -eq 3 ]] && [[ "$first" == "false" ]]; then
            height+="${line:i:1}"
        fi
    done

    if [[ $((startCol + width)) -gt "$maxWidth" ]]; then
        maxWidth=$((startCol + width))
    fi

    if [[ $((startRow + height)) -gt "$maxHeight" ]]; then
        maxHeight=$((startRow + height))
    fi  

    inputArr+=("$startCol")
    inputArr+=("$startRow")
    inputArr+=("$width") 
    inputArr+=("$height")

done < "input.txt"

declare -a fabric

for (( i=0; i<maxWidth*maxHeight; i++ )); do
    fabric[$i]='.'
done

startCol=0
startRow=0
width=0
height=0

for (( i=0; i<${#inputArr[@]}; i++ )); do
    
    if [[ $((i % 4)) -eq 0 ]]; then
        startCol="${inputArr[$i]}"
    elif [[ $((i % 4)) -eq 1 ]]; then
        startRow="${inputArr[$i]}"
    elif [[ $((i % 4)) -eq 2 ]]; then
        width="${inputArr[$i]}"
    else
        height="${inputArr[$i]}"

        for (( j=startRow; j<startRow+height; j++ )); do
            for (( k=startCol; k<startCol+width; k++ )); do
                if [[ "${fabric[$((j * maxWidth + k))]}" == '.' ]]; then
                    fabric[$((j * maxWidth + k))]='o'
                elif [[ "${fabric[$((j * maxWidth + k))]}" == 'o' ]]; then
                    fabric[$((j * maxWidth + k))]='x'
                fi
            done
        done
    fi
done

overlap=0

for (( i=0; i<${#fabric[@]}; i++ )); do
    if [[ "${fabric[$i]}" == 'x' ]]; then
        overlap=$((overlap + 1))
    fi
done

echo $overlap