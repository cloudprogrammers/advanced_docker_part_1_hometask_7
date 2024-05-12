#!/bin/bash
# Continuously check the status of the Nginx server and send email alerts if it's down

while true; do
  if ! curl -s http://nginx; then # ENSURE nginx is in the same Docker network!
    #echo "Subject: Alert - Nginx Down" | sendmail -f office@cloudprogrammers.pl -v mateuszpoland6@gmail.com
    echo "Nginx is down. An alert email has been sent." >> /var/log/nginx_watcher.log
  else
    echo "Nginx is running." >> /var/log/nginx_watcher.log
  fi
  sleep 60  # check every minute
done