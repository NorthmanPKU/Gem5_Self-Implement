#!/bin/bash
tmpf=$0.fifo       #命名管道
mkfifo $tmpf       #创建管道
exec 4<>$tmpf      #创建文件描述符4，以读写方式操作管道
rm $tmpf        #删除创建的管道

thred=10         #指定并发数
seq=(1 2 3 4 5 6 7 8 9 21 22 23 24 25 31 32 33 34 35)     #创建线程的任务列表

#为并发线程创建相应个数的占位
{
  for (( i = 1;i<=${thred};i++ ))
  do
    echo;             #因read命令读取一行，而echo默认输出换行符，所以为每个线程输出占位换行
  done
} >&4                  #将占位写入管道（输出给文件描述符4 --> &4 的作用，如果不加 "&" 会被bash解释为文件名）


# for i in three_level sep_two_level new_two_level
# do
#     read -u 4  
#     (build/ARM/gem5.opt --outdir=./configs/proj3/output/lab1/$i configs/proj3/$i.py; echo >&4; echo -n `date`;) &   
# done
for workload in tmm bfs
do
    for threshold in -2 -1 0 1 2
    do
        for hislength in 22 32 42 52 62
        do
            for pertablesize in 1024 2048 4096 8192 16384
            do
                read -u 4
                (build/ARM/gem5.opt --outdir=./configs/proj5/output/lab23/${threshold}_${hislength}_${pertablesize}_${workload} configs/proj5/two-level.py --threshold=${threshold} --hislength=${hislength} --pertablesize=${pertablesize} --perceptronsbp --$workload; echo >&4; echo -n `date`;) &
            done
        done
    done
done

date
echo "####################____________________END_______________________####################"
wait            #阻塞等待所有在此脚本中的后台任务："{.....}&" 完成
exec 4>&-        #关闭管道