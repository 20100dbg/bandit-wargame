#!/bin/bash

python /etc/bandit_scripts/script14.py &
python /etc/bandit_scripts/script15.py &
python /etc/bandit_scripts/script16.py &
sudo -u bandit22 /usr/bin/cronjob_bandit22.sh &
sudo -u bandit23 /usr/bin/cronjob_bandit23.sh &
sudo -u watch -n 60 bandit24 /usr/bin/cronjob_bandit24.sh &
python /etc/bandit_scripts/script25.py &
sudo -u bandit35 /usr/bin/cronjob_bandit35.sh &

/usr/sbin/sshd -D

wait -n
exit $?