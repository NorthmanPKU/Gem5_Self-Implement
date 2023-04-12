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
wait            #�����ȴ������ڴ˽ű��еĺ�̨����"{.....}&" ���
exec 4>&-        #�رչܵ�