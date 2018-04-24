#!/bin/bash
#Script to output unique and active users email deivered via a SpamExperts system
server=<servername>
user=<username>
pass=<pass>
to_date=`date +%s`;
from_date=`date -d '30 days ago' +'%s'`;
#echo $to_date;
#echo $from_date;
from=`date -d @$from_date +"%y-%m-%d"`;
to=`date -d @$to_date +"%y-%m-%d"`;
echo "All unique & active recipients for the ADMIN: $1 between "$from" and "$to;
curl -s  --insecure 'https://'"$user"':'"$pass"'@'"$server"'/cgi-bin/api?call=api_list_domains&sort=domain&filter_by=%5B%5B%22admin%20name%22%2C%22'"$1"'%22%2C%22is%22%5D%5D' | awk -F ':' {'print $1'} | \
while read domain;\
do
if [ -n "$domain" ]; then
echo " "; echo -n "* Domain: " $domain ": ";
recipients=`curl -s --insecure 'https://'"$user"':'"$pass"'@'"$server"'/cgi-bin/api?call=api_find_messages&domain='"$domain"'&sender=&from_date='"$from_date"'&to_date='"$to_date"'&columns=recipient,status&status=delivered' | \
grep "delivered" | awk -F "," {'print $1'} | tr -d " " | tr '[A-Z]' '[a-z]' | sort | uniq | wc -l`; echo -n $recipients" recipients";
fi;
done;
echo " ";
echo " ";
echo "Please note that these counts reflect status delivered emails only for the admin: $1. If a domain has NO accepted mails for that period, it will NOT be shown/counted";
echo " ";
