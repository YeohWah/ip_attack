#!/bin/bash
##http://www.vsyour.com/post/140.html
num=100 #����
cd /home/wwwlogs
#��ȡ����1000����¼�������IP����100���ͷ����
for i in tail access.log -n 1000|awk '{print $1}'|sort|uniq -c|sort -rn|awk '{if ($1>$num){print $2}}'
do
      iptables -I INPUT -p tcp -s $i --dport 80 -j DROP
done