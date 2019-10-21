#!/usr/bin/env bash



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

