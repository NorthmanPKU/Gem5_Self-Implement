#!/bin/bash
#!/bin/bash
#by inmoonlight@163.com

#下面的代码控制并发数。其实是利用令牌原理实现
#一个线程要运行，首先要拿到令牌在该代码中即read一行数据，读取不到就会暂停，否则就拿到数据就运行命令，当完成后将令牌放回
#将令牌放回即再在管道文件中写入一行数据，这里的数据是换行符，echo >&4。这样另外的线程就可以再读该数据（拿到令牌）并运行

#!/bin/bash
tmpf=$0.fifo       #命名管道
mkfifo $tmpf       #创建管道
exec 4<>$tmpf      #创建文件描述符4，以读写方式操作管道
rm $tmpf        #删除创建的管道

thred=13         #指定并发数
seq=(1 2 3 4 5 6 7 8 9 21 22 23 24 25 31 32 33 34 35)     #创建线程的任务列表

#为并发线程创建相应个数的占位
{
  for (( i = 1;i<=${thred};i++ ))
  do
    echo;             #因read命令读取一行，而echo默认输出换行符，所以为每个线程输出占位换行
  done
} >&4                  #将占位写入管道（输出给文件描述符4 --> &4 的作用，如果不加 "&" 会被bash解释为文件名）

# for id in ${seq[*]}            #从任务列表"seq"按顺序获取任务，或：for id in ${seq}
# do
#   read                      #读取一行，即fd4中的一个占位符
#   (./command ${id}; echo >&4 ) &      #在后台执行任务command并将任务${id}赋予当前任务command；执行完成后在fd4中写入一个换行占位 ，"&" 即将其之前部分放入后台实现并行执行
# done <&4         #指定fd4为整个for的stdin（读取fd4的占位信息）

cntnum2=1
cntnum3=1
cntnum4=1
cntnum5=1
cntnum6=1


#以上流程中read、echo对fd4的交替写和读是并发处理的关键!，可以想象若read读取不到fd4中数据时将等待fd4
list='local tournament bimode'
echo "----------------------------Start lab 6-------------------------------"

for k51 in 8192
do
    for k52 in 512 1024 2048 4096 8192
    do
        for k53 in 2048 4096 8192 16384 32768
        do
            read -u 4
            (./build/ARM/gem5.opt --outdir=./proj2/datas/lab6/bfstournament${k51}${k52}${k53} ./configs/proj2/two-levelbfs.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --tournament --localsize=${k51} --localhissize=${k52} --globalsize=${k53}; echo >&4; echo -n `date`; echo "####################lab6 finish $cntnum6 / 25####################";let cntnum6++) &  
        done
    done
done

date
echo "####################____________________END_______________________####################"
wait            #阻塞等待所有在此脚本中的后台任务："{.....}&" 完成
exec 4>&-        #关闭管道