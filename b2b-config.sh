#!/bin/bash

env=$1
ddl=$2
ddldir=/data/httpd/release/b2b-configuration/B2B-DDL


confdir=/home/jenkins/.jenkins/workspace/b2b
b2bconfdir=/home/jenkins/.jenkins/workspace/b2b-$env/src/main/resources/production
date=`date +%Y-%m-%d`

if [ $env == QA ];then
echo "已接收QA环境构建指令，准备开始构建，请稍等..."

echo "开始生成配置文件..."
yes | cp -rfp $confdir/B2B-QA/* $b2bconfdir/

echo "配置文件生成完毕，开始检测是否有数据库文件更新..."

if [ $ddl == none ];then

echo "本次发版不存在数据库文件更新，开始发送构建B2B项目指令..."

curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-QA/build?token=xuanmengb2bqa

sleep 60


curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-QA/`curl -s https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-QA/lastBuild/api/xml |awk -F '</number>' '{print $1}' |awk -F '<number>' '{print $2}'`/consoleText


echo "构建指令发送完毕，请检查B2B项目构建详情."

else

echo "本次发版存在数据库文件更新，开始进行数据库更新操作..."

mysql -u b2btest -pfMXDyurCjNvHTJQx -h 10.30.204.252 b2b_test < $ddldir/$ddl 

if [ $? -eq 0 ];then

echo "数据库更新完毕，开始发送构建B2B项目指令..."

curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-QA/build?token=xuanmengb2bqa

sleep 60


curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-QA/`curl -s https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-QA/lastBuild/api/xml |awk -F '</number>' '{print $1}' |awk -F '<number>' '{print $2}'`/consoleText

echo "构建指令发送完毕，请检查B2B项目构建详情."

else

echo "数据库文件更新失败，请联系管理员检查构建系统..."

fi

fi

fi


if [ $env == UAT ];then

echo "已接收UAT环境构建指令，准备开始构建，请稍等..."

echo "开始生成配置文件..."
yes | cp -rfp $confdir/B2B-UAT/* $b2bconfdir/

echo "开始替换环境配置..."
sed -i s/'pingan.jzb.supAccountId=11014684178007'/'pingan.jzb.supAccountId=11016798029005'/g $b2bconfdir/ntec.properties

echo "配置文件生成完毕，开始检测是否有数据库文件更新..."

if [ $ddl == none ];then

echo "本次发版不存在数据库文件更新，开始发送构建B2B项目指令..."

curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-UAT/build?token=xuanmengb2buat

sleep 60


curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-UAT/`curl -s https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-UAT/lastBuild/api/xml |awk -F '</number>' '{print $1}' |awk -F '<number>' '{print $2}'`/consoleText

echo "构建指令发送完毕，请检查B2B项目构建详情."

else

echo "本次发版存在数据库文件更新，开始进行数据库更新操作..."

mysql -u b2buat -pb2buat123! -h 10.30.204.252 b2b_uat < $ddldir/$ddl

if [ $? -eq 0 ];then

echo "数据库更新完毕，开始发送构建B2B项目指令..."

curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-UAT/build?token=xuanmengb2buat

sleep 60


curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-UAT/`curl -s https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-UAT/lastBuild/api/xml |awk -F '</number>' '{print $1}' |awk -F '<number>' '{print $2}'`/consoleText

echo "构建指令发送完毕，请检查B2B项目构建详情."

else

echo "数据库文件更新失败，请联系管理员检查构建系统..."

fi

fi

fi


if [ $env == PRE ];then

echo "已接收PRE环境构建指令，准备开始构建，请稍等..."

echo "开始生成配置文件..."
yes | cp -rfp $confdir/B2B-PRO/* $b2bconfdir/

echo "开始替换环境配置..."
sed -i s/'redis.server=127.0.0.1'/'redis.server=87750ec33b05455a.m.cnhza.kvstore.aliyuncs.com'/g $b2bconfdir/redis.properties
sed -i s/'redis.auth=123456'/'redis.auth=87750ec33b05455a:jxEJ7tjnqdEYt9tQ'/g $b2bconfdir/redis.properties
sed -i s/'127.0.0.1:3306\/b2b_test'/'rds6ta9fh0tk546jso41.mysql.rds.aliyuncs.com:3306\/b2b_pro'/g $b2bconfdir/ntec.properties
sed -i s/'jdbc.username=b2btest'/'jdbc.username=b2b'/g $b2bconfdir/ntec.properties
sed -i s/'jdbc.password=fMXDyurCjNvHTJQx'/'jdbc.password=pCWFzqZhVbxtU2bn'/g $b2bconfdir/ntec.properties
sed -i s/'pingan.jzb.supAccountId=11014684178007'/'pingan.jzb.supAccountId=11016798029005'/g $b2bconfdir/ntec.properties


echo "配置文件生成完毕，开始检测是否有数据库文件更新..."

if [ $ddl == none ];then

echo "本次发版不存在数据库文件更新，开始发送构建B2B项目指令..."

curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRE/build?token=xuanmengb2bpre

sleep 60


curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRE/`curl -s https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRE/lastBuild/api/xml |awk -F '</number>' '{print $1}' |awk -F '<number>' '{print $2}'`/consoleText

echo "构建指令发送完毕，请检查B2B项目构建详情."

else

echo "本次发版存在数据库文件更新，开始进行数据库更新操作..."

mysql -u b2b -ppCWFzqZhVbxtU2bn -h rds6ta9fh0tk546jso41.mysql.rds.aliyuncs.com b2b_pro < $ddldir/$ddl

if [ $? -eq 0 ];then

echo "$ddl" >> /tmp/b2bddlreport
echo "数据库更新完毕，开始发送构建B2B项目指令..."

curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRE/build?token=xuanmengb2bpre

sleep 60


curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRE/`curl -s https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRE/lastBuild/api/xml |awk -F '</number>' '{print $1}' |awk -F '<number>' '{print $2}'`/consoleText

echo "构建指令发送完毕，请检查B2B项目构建详情."

else

echo "数据库文件更新失败，请联系管理员检查构建系统..."

fi

fi

fi


if [ $env == PRO ];then

echo "已接收PRE环境构建指令，准备开始构建，请稍等..."

echo "开始生成配置文件..."
yes | cp -rfp $confdir/B2B-PRO/* $b2bconfdir/

echo "开始替换环境配置..."
sed -i s/'redis.server=127.0.0.1'/'redis.server=87750ec33b05455a.m.cnhza.kvstore.aliyuncs.com'/g $b2bconfdir/redis.properties
sed -i s/'redis.auth=123456'/'redis.auth=87750ec33b05455a:jxEJ7tjnqdEYt9tQ'/g $b2bconfdir/redis.properties
sed -i s/'127.0.0.1:3306\/b2b_test'/'rds6ta9fh0tk546jso41.mysql.rds.aliyuncs.com:3306\/b2b_pro'/g $b2bconfdir/ntec.properties
sed -i s/'jdbc.username=b2btest'/'jdbc.username=b2b'/g $b2bconfdir/ntec.properties
sed -i s/'jdbc.password=fMXDyurCjNvHTJQx'/'jdbc.password=pCWFzqZhVbxtU2bn'/g $b2bconfdir/ntec.properties
sed -i s/'pingan.jzb.supAccountId=11014684178007'/'pingan.jzb.supAccountId=11016798029005'/g $b2bconfdir/ntec.properties

echo "配置文件生成完毕，开始检测是否有数据库文件更新..."

if [ $ddl == none ];then

echo "本次发版不存在数据库文件更新，开始发送构建B2B项目指令..."

curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRO/build?token=xuanmengb2bpro

sleep 60


curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRO/`curl -s https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRO/lastBuild/api/xml |awk -F '</number>' '{print $1}' |awk -F '<number>' '{print $2}'`/consoleText

echo "构建指令发送完毕，请检查B2B项目构建详情."

fi

hehe=`grep -Fx "$ddl" /tmp/b2bddlreport |grep -v grep |wc -l`
if [ $ddl != none -a $hehe != 0 ];then

echo "本次数据库发版已在PRE环境执行完毕，生产环境无需执行！开始发送构建B2B项目指令..."

curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRO/build?token=xuanmengb2bpro

sleep 60


curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRO/`curl -s https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRO/lastBuild/api/xml |awk -F '</number>' '{print $1}' |awk -F '<number>' '{print $2}'`/consoleText

echo "构建指令发送完毕，请检查B2B项目构建详情."

fi

if [ $ddl != none -a $hehe == 0 ];then

echo "本次发版存在数据库文件更新，开始进行数据库更新操作..."

mysql -u b2b -ppCWFzqZhVbxtU2bn -h rds6ta9fh0tk546jso41.mysql.rds.aliyuncs.com b2b_pro < $ddldir/$ddl

if [ $? -eq 0 ];then

echo "数据库更新完毕，开始发送构建B2B项目指令..."

curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRO/build?token=xuanmengb2bpro

sleep 60


curl https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRO/`curl -s https://root:E6NMSPEmdAhYfqeG@jenkins.alaxiaoyou.com/view/B2B/job/b2b-PRO/lastBuild/api/xml |awk -F '</number>' '{print $1}' |awk -F '<number>' '{print $2}'`/consoleText

echo "构建指令发送完毕，请检查B2B项目构建详情."

else

echo "数据库文件更新失败，请联系管理员检查构建系统..."

fi

fi

fi

if [ $env != QA -a $env != UAT -a $env != PRE -a $env != PRO ];then
echo "输入环境名称有误，请按照备注提示重新输入！"
echo "警告，B2B配置文件jenkins项目有人随意输入错误参数！"  |mail -s "B2B配置文件项目告警" yuhuanghui@alaxiaoyou.com
fi
