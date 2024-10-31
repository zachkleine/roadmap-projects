#!/bin/bash

get_server_stats() {
    echo "Server stats for: "$(hostname)
    echo "OS Version:" $(cat /etc/os-release | grep -i 'PRETTY_NAME' | cut -d "=" -f2 | tr -d '"')
    echo "System Uptime: $(uptime -p | awk -F 'up ' '{print $2}')"
    echo "Load Average (last minute): $(uptime | awk -F 'load average:' '{print $2}' | tr -d ' ' | cut -d "," -f1)"
    echo "Load Average (last 5 minutes): $(uptime | awk -F 'load average:' '{print $2}' | tr -d ' ' | cut -d "," -f2)"
    echo "Load Average (last 15 minutes): $(uptime | awk -F 'load average:' '{print $2}' | tr -d ' ' | cut -d "," -f3)"
    echo "Number of users logged in:$(top -bn1 | grep -i 'users' | cut -d ',' -f2)"
    echo "Number of failed login attempts: "
}
get_cpu_usage() {  
    top -bn1 | grep -i "%Cpu(s):" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "CPU Usage: " 100 - $1"%"}'
}
get_mem_usage() {  
    totalmem=$(top -bn1 | grep -i 'Mib Mem' | sed 's/.* \([0-9.]*\) total.*/\1/')
    freemem=$(top -bn1 | grep -i 'Mib Mem' | sed 's/.* \([0-9.]*\) free.*/\1/')
    usedmem=$(top -bn1 | grep -i 'Mib Mem' | sed 's/.* \([0-9.]*\) used.*/\1/')
    echo "Total Memory Free: $(echo "scale=2; 100-($freemem/$totalmem)" | bc)%"
    echo "Total Memory Used: $(echo "scale=2; $usedmem/$totalmem" | bc)%"
}
get_disk_usage() {  
    df -h --total | grep -i 'total' | sed 's/.* \([0-9]*%\).*/\1/' | awk '{print "Total Used Disk Space: "$1}'
    df -h --total | grep -i 'total' | sed 's/.* \([0-9]*%\).*/\1/' | awk '{print "Total Free Disk Space: " 100 - $1}'
}
get_5cpu_process(){
    echo -e "Top 5 CPU Processes:\n$(ps -eo pid,user,%cpu,comm --sort=-%cpu | head -n 6)"
}
get_5mem_process(){
    echo -e "Top 5 CPU Processes:\n$(ps -eo pid,user,%mem,comm --sort=-%mem | head -n 6)"
}

get_server_stats
get_cpu_usage
get_mem_usage
get_disk_usage
get_5cpu_process
get_5mem_process