#!/bin/bash
archive_logs() {
    sudo -v
    echo "Archiving logs from $1"

    outputdir=/var/log_archive
    if [ ! -d $outputdir ]; then
        echo "Creating directory $outputdir"
        sudo mkdir -p $outputdir
    fi

    outfile="$outputdir/logs_archive_${timestamp=$(date +"%Y%m%d_%H%M%S")}.tar.gz"
    echo "Compressing logs from $1 to $outfile"
    sudo tar -czf "$outfile" $1
    
    echo "Clearing logs from $1"
    sudo rm -r $1/*
}

echo "Welcome to the log archive tool"
while true; do
    echo "1. Archive Logs"
    echo "2. Change Log Archive Schedule"
    echo "3. End"

    read -rp "Choose an option 1-3: " menuChoice

    case $menuChoice in
        1) echo "Beginning log archival process"
           read -p "What directory do you want to archive? Default is " -i /var/log -e dirChoice
           echo "Selected directory is $dirChoice"
           archive_logs $dirChoice
        ;;
        2) echo "Changing log archival schedule"
        ;;
        3) echo "Goodbye"
           break
        ;;
        *) echo "invalid choice. try again"
        ;;
    esac
done