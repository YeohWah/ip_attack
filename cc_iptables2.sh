#!/bin/bash
##http://yzs.me/2050.html
#����ban_now
ban_now() {
#���IP������
echo $1
#ִ��iptables�Ը�IP���
iptables -I INPUT -s $1 -p all -j DROP
#�����ִ��mail�����ָ�����䷢һ���ʼ�
echo -e "IP:$1 was banned at $(date).\n\niptables filter tables:\n\n$(iptables -L -n -t filter)" | mail -s "IP:$1 was banned at $(date)" your@email.com
}
#ѭ���Ŀ�ʼ
while [ "$loop" = "" ]
do
#�����־�ļ�
cat>/var/log/nginx/iponly.log<<EOF
EOF
#�ӳ�����
ping -c 5 127.0.0.1 >/dev/null 2>&1
#�ϲ�������IP�������ȡ����������IP��������������������IP֮��ʹ��Ӣ�Ķ��Ÿ�����Ȼ��ֵ��connections
connections=$(cat /var/log/nginx/iponly.log | sort -n | uniq -c | sort -nr | awk '{print $1 "," $2}')
#�жϱ���connections�Ƿ�Ϊ��
if [ "$connections" != "" ];then
#�������connections������
  echo $connections
#��������forѭ����ʼ
  for ipconntctions in $connections
    do
#��ȡ������
      connectnumber=$(echo $ipconntctions | cut -d "," -f 1)
#�жϸ�IP�������Ƿ����200
      test $connectnumber -ge 200 && banit=1
#����200����IP��ֵ������fuckingip
      if [ "$banit" = "1" ];then
          fuckingip=$(echo $ipconntctions | cut -d "," -f 2)
          ban_now $fuckingip
          unset banit
      else
#���򣬽���forѭ��
          break
      fi
     done
fi
done