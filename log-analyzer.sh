#!/bin/bash
get-logs() {
    if [ ! -f "nginx-access.log" ]; then
        curl -s https://gist.githubusercontent.com/kamranahmedse/e66c3b9ea89a1a030d3b739eeeef22d0/raw/77fb3ac837a73c4f0206e78a236d885590b7ae35/nginx-access.log -o nginx-access.log
    fi
}

get-output() {
    while read -r count value; do
        echo "$value - $count requests"
    done <<< "$1"
}

get-logs

IPs=$(awk '{print $1}' nginx-access.log | sort | uniq -c | sort -nr | head -5)
paths=$(awk '{print $7}' nginx-access.log | sort | uniq -c | sort -nr | head -5)
statuscodes=$(sed 's/[^"]*"[^"]*"\s*//' nginx-access.log | cut -d' ' -f1 | sort | uniq -c | sort -nr | head -5)
useragents=$(awk -F'"' '{print $(NF-1)}' nginx-access.log | sort | uniq -c | sort -nr | head -5)
output_data=("$IPs" "$paths" "$statuscodes" "$useragents")

titles=("Top 5 IP addresses with the most requests:" "Top 5 most requested paths:" "Top 5 response status codes:" "Top 5 user agents:")

for i in "${!titles[@]}"; do 
    echo "${titles[$i]}"
    get-output "${output_data[$i]}"
    echo
done 