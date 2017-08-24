#!/bin/bash
export LANG=zh_CN.utf8
d1=`date -d "yesterday" +%Y-%m-%d`
d2=`date +%Y%m%d`
log=$1.access.log
log_path="/data/managelog/logs"
logpath1=/data/managelog/bbc-web1
logpath2=/data/managelog/bbc-web2

##生成报告的时间
maketime=`date +%Y-%m-%d" "%H":"%M`

##同步日志
rsync -vzrtopg --numeric-ids --progress --password-file=/etc/rsyncd.password8 root@10.47.88.240::log /data/managelog/bbc-web1/ 1>/dev/null 2>&1
rsync -vzrtopg --numeric-ids --progress --password-file=/etc/rsyncd.password8 root@10.47.88.253::log /data/managelog/bbc-web2/ 1>/dev/null 2>&1

##解压log日志
yes | cp $logpath1/$log-$d2.gz $log_path
gunzip $log_path/$log-$d2.gz
gunzip $logpath2/$log-$d2.gz
cat $logpath2/$log-$d2 >> $log_path/$log-$d2

##总访问量
total_visit=`awk '{print $1}' $log_path/$log-$d2 |wc -l`

##独立访客
total_unique=`awk '{print $1}' $log_path/$log-$d2 |sort |uniq -c |wc -l`

##总带宽
#total_bw=`awk '{print $10}' $log_path/$log-$d2 |sort -rn | awk '{a+=$1}END{print a/1024/1024}'`
total_bw=`awk -v total=0 '{total+=$10}END{print total/1024/1024}' $log_path/$log-$d2`

##访问IP统计
ip_pv=`awk '{print $1}' $log_path/$log-$d2 |grep -v "127.0.0.1" |sort |uniq -c |sort -rn |head -22`

##PV统计
PV=`awk '{print $7}' $log_path/$log-$d2 |sort |uniq -c |sort -rn |head -20`

##内部调用总次数
#neiwang=`grep "^10\." $log_path/$log-$d2 |sort |uniq -c |wc -l`
##内部调用url
#total_neiwang=`grep "^10\." $log_path/$log-$d2 |sort |uniq -c |sort -rn`

##状态码
error403=`grep -v HEAD $log_path/$log-$d2 |awk '{if($9 ~ 403) print $0}' |sort |uniq -c |sort -rn |head -20`
error404=`grep -v HEAD $log_path/$log-$d2 |awk '{if($9 ~ 404) print $0}' |sort |uniq -c |sort -rn |head -20`
error500=`awk '{if($9 ~ 500) print $0}' $log_path/$log-$d2 |sort |uniq -c |sort -rn |head -20`
error501=`awk '{if($9 ~ 501) print $0}' $log_path/$log-$d2 |sort |uniq -c |sort -rn |head -20`
error502=`awk '{if($9 ~ 502) print $0}' $log_path/$log-$d2 |sort |uniq -c |sort -rn |head -20`
error503=`awk '{if($9 ~ 503) print $0}' $log_path/$log-$d2 |sort |uniq -c |sort -rn |head -20`
error504=`awk '{if($9 ~ 504) print $0}' $log_path/$log-$d2 |sort |uniq -c |sort -rn |head -20`


#echo -e "$2\n概况\n统计时间段：${d1}\n报告生成时间：${maketime}\n总访问量:${total_visit}\n独立访客:${total_unique}\n\n访问IP统计\n${ip_pv}\n\n访问url统计\n${PV}\n\n内部调用总次数\n${neiwang}\n\n内部调用url\n{$total_neiwang}\n\n403统计\n${error403}\n\n404统计\n${error404}\n\n500Error\n${error500}\n\n501Error\n${error501}\n\n502Error\n${error502}\n\n503Error\n${error503}\n\n504Error\n${error504}\n\n"| unix2dos > /root/script/$log
echo -e "$2\n概况\n统计时间段：${d1}\n报告生成时间：${maketime}\n总访问量:${total_visit}\n总带宽:${total_bw}M\n独立访客:${total_unique}\n\n访问IP统计\n${ip_pv}\n\n访问url统计\n${PV}\n\n403统计\n${error403}\n\n404统计\n${error404}\n\n500Error\n${error500}\n\n501Error\n${error501}\n\n502Error\n${error502}\n\n503Error\n${error503}\n\n504Error\n${error504}\n\n"| dos2unix | mail -s "$2" yuhuanghui@alaxiaoyou.com luchuang@alaxiaoyou.com zhuhongyuan@alaxiaoyou.com lvjun@alaxiaoyou.com

gzip $log_path/$log-$d2
gzip $logpath2/$log-$d2
