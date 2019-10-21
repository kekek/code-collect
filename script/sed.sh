## 批量替换 git 模版数据
# sed -i '' -e "s/http:\/\/static.ktkt.com/\/\/static.ktkt.com/g"  $(git grep -l static.ktkt.com templates/ | uniq)

