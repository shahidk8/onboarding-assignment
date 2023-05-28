#!/bin/bash

#Define log files variables
FILE_PATH=logfile.log
FETCH_LOG=output.log
temp=output2.log

#clear log files if any data
: > $temp
: > $FETCH_LOG

#sort according to fifth slice of each new line that is time in miliseconds.
sort -k 5nr $FILE_PATH > $temp && mv $temp $FILE_PATH && echo "Longest Time Response\n" >> $FETCH_LOG;

line=$(head -n 1 $FILE_PATH)
line_length=${#line}

#find request for the completed response
if ((line_length > 0)) 
then

    completed=$(echo "$line" | cut -d':' -f4 | cut -d' ' -f1)
    if [ "$completed" = "Completed" ]; then
        index=$(echo "$line" | cut -d':' -f1)
        result=$((index-1))
        start=$(grep "$result" $FILE_PATH)
        echo "$start\n" >> $FETCH_LOG
        echo "$line\n" >> $FETCH_LOG
    fi
fi

#get count of all requests, ignoring request query.
awk '/Started/ {print $2, $3}' logfile.log |  sed 's/\?.*$/\"/' | sort -n | uniq -c | sort -nr >> $FETCH_LOG