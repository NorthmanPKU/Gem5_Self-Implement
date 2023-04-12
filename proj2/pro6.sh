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

thred=10         #ָ��������
seq=(1 2 3 4 5 6 7 8 9 21 22 23 24 25 31 32 33 34 35)     #�����̵߳������б�

#Ϊ�����̴߳�����Ӧ������ռλ
{
  for (( i = 1;i<=${thred};i++ ))
  do
    echo;             #��read�����ȡһ�У���echoĬ��������з�������Ϊÿ���߳����ռλ����
  done
} >&4                  #��ռλд��ܵ���������ļ�������4 --> &4 �����ã�������� "&" �ᱻbash����Ϊ�ļ�����

# for id in ${seq[*]}            #�������б�"seq"��˳���ȡ���񣬻�for id in ${seq}
# do
#   read                      #��ȡһ�У���fd4�е�һ��ռλ��
#   (./command ${id}; echo >&4 ) &      #�ں�ִ̨������command��������${id}���赱ǰ����command��ִ����ɺ���fd4��д��һ������ռλ ��"&" ������֮ǰ���ַ����̨ʵ�ֲ���ִ��
# done <&4         #ָ��fd4Ϊ����for��stdin����ȡfd4��ռλ��Ϣ��

cntnum2=1
cntnum3=1
cntnum4=1
cntnum5=1
cntnum6=1


#����������read��echo��fd4�Ľ���д�Ͷ��ǲ�������Ĺؼ�!������������read��ȡ����fd4������ʱ���ȴ�fd4
list='local tournament bimode'
echo "----------------------------Start lab 2-------------------------------"
for i in 2mm bfs
do
    echo "i = $i"
    for j in $list
    do
    #echo $i
        echo "j = $j"
        for k in 1024 2048 4096 8192 16384
        do
            echo "im here"
            read -u 4
            echo "read finish"
            (./build/ARM/gem5.opt --outdir=./proj2/datas/lab2/${i}${j}${k} ./configs/proj2/two-level${i}.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --${j} --btbentry=${k}; echo >&4; echo -n `date`;echo 'date lab2 finish $cntnum2 / 30';let cntnum2++) &                 
        done
    done
done
echo "----------------------------Start lab 3-------------------------------"
for i3 in 2mm bfs
do
    for j3 in $list
    do
    #echo $i
        for k3 in 4 8 16 32 64
        do
            read -u 4  
            (./build/ARM/gem5.opt --outdir=./proj2/datas/lab3/${i3}${j3}${k3} ./configs/proj2/two-level${i3}.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --${j3} --ras=${k3}; echo >&4; echo -n `date`;echo "lab3 finish $cntnum3 / 30";let cntnum3++) &                 
        done
    done
done
echo "----------------------------Start lab 4-------------------------------"

for k4 in 512 1024 2048 4096 8192
do
    read -u 4
    (./build/ARM/gem5.opt --outdir=./proj2/datas/lab4/bfslocal${k4} ./configs/proj2/two-levelbfs.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --local --localsize=${k4} ; echo >&4; echo -n `date`;echo "lab4 finish $cntnum4 / 5";let cntnum4++) &  
done

echo "----------------------------Start lab 5-------------------------------"
for k5 in 2048 4096 8192 16384 32768
do
    read -u 4
    (./build/ARM/gem5.opt --outdir=./proj2/datas/lab5/bfsbimode${k5} ./configs/proj2/two-levelbfs.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --bimode --globalsize=${k5} ; echo >&4; echo -n `date`; echo "lab5 finish $cntnum5 / 5";let cntnum5++) &  
done

echo "----------------------------Start lab 6-------------------------------"

for k51 in 512 1024 2048 4096 8192
do
    for k52 in 512 1024 2048 4096 8192
    do
        for k53 in 2048 4096 8192 16384 32768
        do
            read -u 4
            (./build/ARM/gem5.opt --outdir=./proj2/datas/lab6/bfstournament${k51}${k52}${k53} ./configs/proj2/two-levelbfs.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --tournament --localsize=${k51} --localhissize=${k52} --globalsize=${k53}; echo >&4; echo -n `date`; echo "lab6 finish $cntnum6 / 125";let cntnum6++) &  
        done
    done
done

date
echo "####################____________________END_______________________####################"
wait            #�����ȴ������ڴ˽ű��еĺ�̨����"{.....}&" ���
exec 4>&-        #�رչܵ�