#!/bin/bash
declare -a records 

while IFS= read -r line || [[ -n "$line" ]]; do
    records+=("$line")
done < "input.txt"

for (( i=0; i<${#records[@]} - 1; i++ )); do
    for (( j=0; j<${#records[@]} - $i - 1; j++ )); do
        if [[ 10#${records[j]:6:2} -gt 10#${records[j + 1]:6:2} ]]; then
            temp="${records[j]}"
            records[j]="${records[j + 1]}"
            records[j + 1]="$temp"
        elif [[ 10#${records[j]:6:2} -eq 10#${records[j + 1]:6:2} ]]; then
            if [[ 10#${records[j]:9:2} -gt 10#${records[j + 1]:9:2} ]]; then
                temp="${records[j]}"
                records[j]="${records[j + 1]}"
                records[j + 1]="$temp"
            elif [[ 10#${records[j]:9:2} -eq 10#${records[j + 1]:9:2} ]]; then
                if [[ 10#${records[j]:12:2} -gt 10#${records[j + 1]:12:2} ]]; then
                    temp="${records[j]}"
                    records[j]="${records[j + 1]}"
                    records[j + 1]="$temp"
                elif [[ 10#${records[j]:12:2} -eq 10#${records[j + 1]:12:2} ]]; then
                    if [[ 10#${records[j]:15:2} -gt 10#${records[j + 1]:15:2} ]]; then
                        temp="${records[j]}"
                        records[j]="${records[j + 1]}"
                        records[j + 1]="$temp"
                    fi
                fi
            fi
        fi
    done
done

awake="............................................................"
declare -a sleep
declare -A sleepPerG
sleepCount=0
maxGCount=0;

for (( i=0; i<${#records[@]}; i++ )); do
    if [[ "${records[i]:19:1}" == "G" ]]; then
        sleep+=("$awake") 
        ((sleepCount++))
        j=26
        currG=""
        while [[ "${records[i]:j:1}" != " " ]]; do
            sleep[sleepCount - 1]+="${records[i]:j:1}"
            currG+="${records[i]:j:1}"
            ((j++))
        done
    elif [[ "${records[i]:19:1}" == "f" ]]; then
        sleepStart=10#${records[i]:15:2}
    elif [[ "${records[i]:19:1}" == "w" ]]; then
        sleepEnd=10#${records[i]:15:2}
        if [[ -v sleepPerG["$currG"] ]]; then
            sleepPerG["$currG"]=$((sleepPerG["$currG"] + sleepEnd - sleepStart))
        else
            sleepPerG["$currG"]=$((sleepEnd - sleepStart))
        fi

        if [[ 10#${sleepPerG["$currG"]} -gt 10#$maxGCount ]]; then
            maxGCount=${sleepPerG["$currG"]}
            maxG="$currG"
        fi

        for (( k=sleepStart; k<sleepEnd; k++ )); do
            temp="${sleep[sleepCount - 1]:0:k}#"
            sleep[sleepCount - 1]="${temp}${sleep[sleepCount - 1]:k+1}"
        done
    fi
done

declare -A minuteCounts
maxMinCount=0

for (( i=0; i<${#sleep[@]}; i++ )); do
    if [[ "${sleep[i]:60}" == "$maxG" ]]; then
        for (( j=0; j<${#sleep[i]}; j++ )); do
            if [[ "${sleep[i]:j:1}" == "#" ]]; then
                if [[ -v minuteCounts["$j"] ]]; then
                    minuteCounts["$j"]=$((minuteCounts["$j"] + 1))   
                else
                    minuteCounts["$j"]=1
                fi

                if [[ ${minuteCounts["$j"]} -gt $maxMinCount ]]; then
                    maxMinCount=${minuteCounts["$j"]}
                    maxMin=$j
                fi
            fi
        done
    fi
done

echo $((maxG * maxMin))