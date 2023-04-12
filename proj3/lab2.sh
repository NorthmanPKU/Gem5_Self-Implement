
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


#����������read��echo��fd4�Ľ���д�Ͷ��ǲ�������Ĺؼ�!������������read��ȡ����fd4������ʱ���ȴ�fd4

for i in MyMRU MRU LRU Random FIFO
do
  for j in mm bfs bzip2 mcf
  do
    read -u 4  
    (build/ARM/gem5.opt --outdir=./configs/proj3/output/lab2/${i}_${j} configs/proj3/two_level.py --$i --$j; echo >&4; echo -n `date`;echo "${i}_${j} finished";) &   
  done
done

# echo "----------------------------Start lab 3-------------------------------"
# for i3 in 2mm bfs
# do
#     for j3 in $list
#     do
#     #echo $i
#         for k3 in 4 8 16 32 64
#         do
#             read -u 4  
#             (./build/ARM/gem5.opt --outdir=./proj2/datas/lab3/${i3}${j3}${k3} ./configs/proj2/two-level${i3}.py --o3 --cpu_clock=4GHz --ddr3_2133_8x8 --${j3} --ras=${k3}; echo >&4; echo -n `date`;echo "lab3 finish $cntnum3 / 30";let cntnum3++) &                 
#         done
#     done
# done

date
echo "####################____________________END_______________________####################"
wait            #�����ȴ������ڴ˽ű��еĺ�̨����"{.....}&" ���
exec 4>&-        #�رչܵ�