#!/bin/bash

crons=("cron_job1" "cron_job2") # List of cron jobs to check
for cron in "${crons[@]}"; do
	# Get last time cron did run
	last_time_cron_ran=$(grep "$cron" /var/log/syslog | tail -n 1 | awk '{print $1,$2,$3}')

	# Convert to timestamp and calculate difference with current timestamp
	cron_timestamp=$(date -d "${last_time_cron_ran}" +"%s")
	current_timestamp=$(date +%s)
	diff=$(($current_timestamp-$cron_timestamp))

	# If difference is more than half hour send mail to alert
	if [ $diff -gt 1800 ]; then
		{
			echo "Subject: Cron Job Alert"
			echo
			echo "It has been $diff seconds since $cron last ran."
		} | /usr/sbin/sendmail email@email.com
	fi
done

