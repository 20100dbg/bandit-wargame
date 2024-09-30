#!/bin/bash

tmp_file=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

chmod 644 /tmp/$tmp_file
cat /etc/bandit_pass/bandit22 > /tmp/$tmp_file