#!/bin/bash

max_str=("" "" "")
path=("" "" "")
length=("" "" "")
num=("" "" "")

function find_words() {
    #查询文本，更新字符串,长度，行号, 路径
    words=`cat $1 | tr -s -c "a-zA-Z0-9" "\n"`    #那个strings会把注释那段/*解析
    for i in $words; do
        len=${#i}    #字符串长度
        line_num=`grep -n $i $1 | head -n 1 | cut -d ":" -f 1`    #获取字符串所在文本行号
        if [[ $len -gt ${length[0]} ]]; then
            for i in `seq 2 1`; do
                length[$i]=${length[$i-1]}
                max_str[$i]=${max_str[$i-1]}
                path[$i]=${path[$i-1]}
                num[$i]=${num[$i-1]}
            done
            length[0]=$len
            max_str[0]=$i
            path[0]=$1
            num[0]=$line_num
        elif [[ $len -gt ${length[1]} ]]; then
            length[2]=${length[1]}
            max_str[2]=${max_str[1]}
            path[2]=${path[1]}
            num[2]=${num[1]}
            
            length[1]=$len
            max_str[1]=$i
            path[1]=$1
            num[1]=$line_num
        elif [[ $len -gt ${length[2]} ]]; then
            length[2]=$len
            max_str[2]=$i
            path[2]=$1
            num[2]=$line_num
        fi
    done;
}

function filter() {    #判断文件是否为特殊类型文件进行过滤
    a=(o rmvb png img jpg jpeg gif md avi zip tar gz 7z)
    suffix=`echo $1 | awk -F. '{print $NF}'`    #提取后缀
    echo ${a[*]} | grep "$suffix" > /dev/null

    if [[ $? -eq 0 ]]; then
        #echo $1"需要过滤"
        return 1    #需要过滤
    fi
    return 0    #不需要过滤
}

function Exec() {
    file $1 | grep "exec" >/dev/null
    if [[ $? -eq 1 ]]; then
        filter $1    #不是可执行程序，开始判断是否需要过滤
        if [[ $? -eq 0 ]]; then    #不需要过滤
        find_words $1    #查询文本中字符串
        fi
    fi
}

function find_file() {
    for i in `ls -A $1`; do
        dir_or_file="$1/$i"
        if [[ -d $dir_or_file ]]; then    #忘了加$，卡一万个小时
            
            find_file ${dir_or_file}
        else
            Exec ${dir_or_file}
        fi
    done
}
hostname=`hostname`
IFS=$'\n'
find_file $1
for i in `seq 0 2`; do
    echo -e "${length[$i]}:${max_str[$i]}\t$hostname:${path[$i]}\tLine:${num[$i]}" #字符串 路径 行号 字符串长度
done
        
