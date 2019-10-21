#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/mysql/bin:/root/bin

set -e

###  jl_base_1102 根据ID来
# format tableName|flag|order
tablesParams=(
"jl_base_2038|id|ReportDate-desc,id-desc"
"jl_base_2015|id|InputTime-desc,id-desc"
"jl_base_2016|id|InputTime-desc,id-desc"
"jl_base_2014|id|InputTime-desc,id-desc"
"jl_base_2008|id|InputTime-desc,id-desc"
"jl_base_2115|id|InputTime-desc,id-desc"
"jl_base_2123|id|InputTime-desc,id-desc"
"jl_base_2046|id|PublishDate-desc,id-desc"
"jl_base_2041|id|InputTime-desc,id-desc"
"jl_base_2042|id|InputTime-desc,id-desc"
"jl_base_2044|id|InputTime-desc,id-desc"
"jl_ext_new_3002|id|ReportDate-desc,id-desc"
"jl_ext_new_3001|id|ReportDate-desc,id-desc"
"jl_ext_3007|id|InputTime-desc,id-desc")

echo "[$(date)] ${tablesParams[@]}-${tablesParams} 开始 =======+++++++++++++++"

for params in ${tablesParams[@]}
do

echo "[$(date)] params ${params} 开始 ========="

################## 查询最后更新日期，或ID等 #####################
    OLD_IFS="$IFS"
    IFS="|"
    arr=($params)
    IFS="$OLD_IFS"

    ### 查询最后更新是时间
    tableName=${arr[0]}
    flagColumnName=${arr[1]}
    orderColumn=${arr[2]}
    backUpFileName="/data/script/sql/${tableName}.sql"

    sql=$(echo "select ${flagColumnName} from $tableName order by ${orderColumn} limit 1" | sed "s/-/ /g")

    echo "[$(date)] ${tableName} | ${flagColumnName} | ${orderColumn} | ${backUpFileName} | ${sql}"

	set +e
# --skip-column-names，-N  忽略字段名称
    lastFlag=$(echo $sql | mysql --login-path=localSync sync -N)
	set -e

    echo "[$(date)] lastFlag : ${lastFlag}"

################## 备份远程服务器数据 #####################
    echo "[$(date)] mysqldump 开始备份远程库"

    where=""
    case "$flagColumnName" in
        "id")
            where="${flagColumnName} >  ${lastFlag:=0}"
        ;;
        *)
            where="${flagColumnName} >  \"${lastFlag:=2010-01-01}\""
        ;;
    esac
    echo "[$(date)] mysql dump : where ${where}"

    mysqldump --login-path=remoteSync --insert-ignore=true -C -v sync ${tableName} --compact -w "${where}" > ${backUpFileName}

    sed -i 's/CREATE TABLE/CREATE TABLE IF NOT EXISTS/g' ${backUpFileName}

################## 倒入备份数据 #####################
    echo "[$(date)] mysql 开始导入本地库"
    cat ${backUpFileName} | mysql --login-path=localSync sync

    echo "[$(date)] params ${params} 完成 ========="
    echo
done
echo "[$(date)] ${tablesParams[@]}-${tablesParams} 结束 =======+++++++++++++++"
echo
echo

# mysql_config_editor set --login-path=localSync --host="10.9.123.21" --port=3306  --user=sync --password

# mysql_config_editor set --login-path=remoteSync --host="106.75.52.21" --port=3306 --user=root  --password
# Enter password: enter password "remotepass" here

# test sql
# mysqldump --login-path
