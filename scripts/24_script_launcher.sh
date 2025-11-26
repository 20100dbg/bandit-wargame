#!/bin/bash

myname=$(whoami)

cd /var/spool/$myname/foo
echo "Executing and deleting all scripts in /var/spool/$myname/foo:"

for f in ./*
do
    if [ "$f" != "." -a "$f" != ".." ];
    then
        echo "Handling $f"
        owner="$(stat --format "%U" $f)"
        if [ "${owner}" = "bandit23" ]; then
            timeout -s 9 60 $f
        fi
        rm -f $f
    fi
done