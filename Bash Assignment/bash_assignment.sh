#!/bin/bash

#Define log files variables
FILE_PATH=logfile.log
FETCH_LOG=output.log
: > $FETCH_LOG
sort -k 5nr $FILE_PATH | head -n 1 | cut -d ':' -f1 | { echo "Longest Time Response\n"; index=$(xargs); grep $((index-1)) $FILE_PATH; grep $index $FILE_PATH; }  >> $FETCH_LOG
awk '/Started/ {print $2, $3}' $FILE_PATH |  sed 's/\?.*$/\"/' | sort -n | uniq -c | sort -nr >> $FETCH_LOG