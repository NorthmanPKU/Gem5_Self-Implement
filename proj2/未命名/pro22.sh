#!/bin/bash
#!/bin/bash
#by inmoonlight@163.com

#����Ĵ�����Ʋ���������ʵ����������ԭ��ʵ��
#һ���߳�Ҫ���У�����Ҫ�õ������ڸô����м�readһ�����ݣ���ȡ�����ͻ���ͣ��������õ����ݾ������������ɺ����ƷŻ�
#�����ƷŻؼ����ڹܵ��ļ���д��һ�����ݣ�����������ǻ��з���echo >&4������������߳̾Ϳ����ٶ������ݣ��õ����ƣ�������

#!/bin/bash
tmpf=$0.fifo       #�����ܵ�
mkfifo $tmpf       #�����ܵ�
exec 4<>$tmpf      #�����ļ�������4���Զ�д��ʽ�����ܵ�
rm $tmpf        #ɾ�������Ĺܵ�

thred=4         #ָ��������
seq=(1 2 3 4 5 6 7 8 9 21 22 23 24 25 31 32 33 34 35)     #�����̵߳������б�

#Ϊ�����̴߳�����Ӧ������ռλ
{
  for (( i = 1;i<=${thred};i++ ))
  do
    echo;             #��read�����ȡһ�У���echoĬ��������з�������Ϊÿ���߳����ռλ����
  done
} >&4                  #��ռλд��ܵ���������ļ�������4 --> &4 �����ã�������� "&" �ᱻbash����Ϊ�ļ�����

for id in ${seq[*]}            #�������б�"seq"��˳���ȡ���񣬻�for id in ${seq}
do
  read                      #��ȡһ�У���fd4�е�һ��ռλ��
  (./command ${id}; echo >&4 ) &      #�ں�ִ̨������command��������${id}���赱ǰ����command��ִ����ɺ���fd4��д��һ������ռλ ��"&" ������֮ǰ���ַ����̨ʵ�ֲ���ִ��
done <&4         #ָ��fd4Ϊ����for��stdin����ȡfd4��ռλ��Ϣ��



#����������read��echo��fd4�Ľ���д�Ͷ��ǲ�������Ĺؼ�!������������read��ȡ����fd4������ʱ���ȴ�fd4
list='local tournament bimode'
echo "----------------------------Start lab 2-------------------------------"
for i in 2mm bfs
do
    for j in $list
    do
    #echo $i
        ./build/ARM/gem5.opt --outdir=./proj2/datas/lab1/${i}${j} ./configs/proj2/two-level${i}.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --${j} &
    done
done
wait
echo "----------------------------End lab 2-------------------------------" 
echo "----------------------------Start lab 2-------------------------------"
list='local tournament bimode'
for i in 2mm bfs
do
    for j in $list
    do
    #echo $i
        ./build/ARM/gem5.opt --outdir=./proj2/datas/lab1/${i}${j} ./configs/proj2/two-level${i}.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --${j} &
    done
done
wait
echo "----------------------------End lab 2-------------------------------" 
echo "----------------------------Start lab 2-------------------------------"
list='local tournament bimode'
for i in 2mm bfs
do
    for j in $list
    do
    #echo $i
        ./build/ARM/gem5.opt --outdir=./proj2/datas/lab1/${i}${j} ./configs/proj2/two-level${i}.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --${j} &
    done
done
wait
echo "----------------------------End lab 2-------------------------------" 
echo "----------------------------Start lab 2-------------------------------"
list='local tournament bimode'
for i in 2mm bfs
do
    for j in $list
    do
    #echo $i
        ./build/ARM/gem5.opt --outdir=./proj2/datas/lab1/${i}${j} ./configs/proj2/two-level${i}.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --${j} &
    done
done
wait
echo "----------------------------End lab 2-------------------------------" 
echo "----------------------------Start lab 2-------------------------------"
list='local tournament bimode'
for i in 2mm bfs
do
    for j in $list
    do
    #echo $i
        ./build/ARM/gem5.opt --outdir=./proj2/datas/lab1/${i}${j} ./configs/proj2/two-level${i}.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --${j} &
    done
done
wait
echo "----------------------------End lab 2-------------------------------" 
echo "----------------------------Start lab 2-------------------------------"
list='local tournament bimode'
for i in 2mm bfs
do
    for j in $list
    do
    #echo $i
        ./build/ARM/gem5.opt --outdir=./proj2/datas/lab1/${i}${j} ./configs/proj2/two-level${i}.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --${j} &
    done
done
wait
echo "----------------------------End lab 2-------------------------------" 


wait            #�����ȴ������ڴ˽ű��еĺ�̨����"{.....}&" ���
exec 4>&-        #�رչܵ�