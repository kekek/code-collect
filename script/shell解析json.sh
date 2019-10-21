#!/usr/bin/env bash


### shell 中解析json

## 1. awk 循环
## 2. python 
## 3. tr 处理文本中引号


# get_json_value $(curl -s http://ip.taobao.com/service/getIpInfo.php?ip=myip) ip
function get_json_value(){
  local json=$1
  local key=$2

  if [[ -z "$3" ]]; then
    local num=1
  else
    local num=$3
  fi

  local value=$(echo "${json}" | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'${key}'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p)

  echo ${value}
}



### python 方式来解析

curl -s 'http://ip.taobao.com/service/getIpInfo.php?ip=myip' | \
    python3 -c "import sys, json; print(json.load(sys.stdin)['data']['ip'])"

## shell 解析数组文件

cat orgin-data.txt | awk -F "[,:}]" '{for(i=1;i<=NF;i++){print $i}}' | tr -d '"' | tr -d '[' | tr -d ']' > list.txt
