for i in `seq 1 10`; do 
    if [[ $i -eq 6 ]]; then
        continue
    fi
    scp Find.sh yuxiaowei@pi$i:.
    ssh yuxiaowei@pi$i "bash Find.sh ~ >./out.log"	#执行脚本 
	scp yuxiaowei@pi$i:./out.log ./pi$i.log 	#取回执行结果
done
cat pi?.log | sort -n -r -t ':' -k 1 | head -n 3	#对结果合并排序取前三位
