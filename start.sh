#!/bin/bash
if [ -z "${CRONTAB_SCHEDULE}" ]; then
    echo "CRONTAB_SCHEDULE environment variable not set, crontab cannot be started. Please set this to a crontab acceptable format. Just running command."
    python /spe/entry.py
else
        # in cron pod
        echo Running cron job pod
        echo "CRONTAB_SCHEDULE is ${CRONTAB_SCHEDULE}"
        ls -la
        mkdir log
        touch cron.log
        ls -la
        pwd $HOME
        touch envs.txt
        ls -la


        # Get the environment from docker saved
        # https://ypereirareis.github.io/blog/2016/02/29/docker-crontab-environment-variables/
        printenv | sed 's/^\([a-zA-Z0-9_]*\)=\(.*\)$/export \1="\2"/g' >> envs.txt
        cat envs.txt
#        printenv | sed 's/^\([a-zA-Z0-9_]*\)=\(.*\)$/export \1="\2"/g' >> $HOME/envs.txt

        echo "${CRONTAB_SCHEDULE} . $HOME/envs.txt; python /spe/entry.py >> /spe/log/cron.log 2>&1" | crontab
        crontab -l && cron -L 15 && tail -f /var/log/cron.log
fi
