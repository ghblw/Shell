for i in `seq 1 10`; do 
	scp Find.sh yuxiaowei@pi$i:.	#拷贝脚本
	ssh yuxiaowei@pi$i "bash Find.sh ~ >./out.log"	#执行脚本 
	scp yuxiaowei@pi$i:./out.log ./pi$i.log 	#取回执行结果
done
grep linenum pi?.log | sort -n -r -t ':' -k 4 | head -n 3	#对结果合并排序取前三位
