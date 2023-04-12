#!/bin/bash
for bp in multiper #mysimplebp localbp tournamentbp
do
  for j in tmm bfs
  do

    # (build/ARM/gem5.opt --outdir=./configs/proj3/output/lab2/${i}_${j} configs/proj3/two_level.py --$j; echo >&4; echo -n `date`;echo "${i}_${j} finished";) &   
    (build/ARM/gem5.opt --outdir=./configs/proj5/output/lab1/${j}_${bp} configs/proj5/two-level.py --$j --$bp;) &
  done
done