#!/usr/bin/env bash


## 1. shell post 请求 -X POST 

## 2. shell get 请求 默认

### 清空code进行测试

function show_help() {
    echo "usage: 清空 并 重新发送signal"
    echo
    echo "example:"
    echo "$0 {code} {signal}"
    echo
    exit 0
}


if [ -z $2 ]; then
    echo "error: signal 不能为空"
    echo

    show_help
    exit 2
fi


if [ -z $1 ]; then
    echo "error: code 不能为空"
    echo

    show_help
    exit 2
fi



signal=$2
code=$1

echo "## clean code by signal"
echo "exec : curl -u ktkt:signal-init -d code=${code}&sig=${signal} http://localhost:1323/del/other"
curl -u "ktkt:signal-init" -d "code=${code}&sig=${signal}" http://localhost:1323/del/other


echo "## send signal"
echo "exec: curl  http://localhost:1323/test/send?code=${code}&s=${signal}&is_stock=1"
curl  "http://localhost:1323/test/send?code=${code}&s=${signal}&is_stock=1"


