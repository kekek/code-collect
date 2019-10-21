#!/bin/sh

## 说明： 从文件读取行，然后， 执行shell脚本
## 1. 读取文件的每一行
## 2. counter 计数器

counter=0

while read CODE
do
	echo "-------------- run code ${CODE} ------------------------"
	/apps/deploy/grpc-f10/shell.sh $CODE 48
	sleep 1

       counter=$((counter+1))
done <$1

echo all job done  ${counter}

echo $CODE
