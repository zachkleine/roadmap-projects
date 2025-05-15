#!/bin/bash

sudo -v
echo "Archiving logs from $1"

outputdir=/var/log_archive
sudo mkdir -p $outputdir
echo "Setting output directory to $outputdir"

timestamp=$(date +"%Y%m%d_%H%M%S")
outfile="$outputdir/logs_archive_$timestamp.tar.gz"
echo "Creating output file $outfile"

echo "Compressing logs from $1 to $outfile"
sudo tar -czf "$outfile" $1

echo "Clearing Logs from $1"
sudo rm -r $1/*

ls /var/log_archive
