#!/bin/bash

# Batch script to loop over fMRI analysis script

scriptdir=
maindir=
cd $maindir

echo "pp","10perc","100perc","100vs10" > $maindir/featquery_beta.csv

for i in `ls -d ??`; do sh $script_dir/fMRI_analysis.sh $maindir/$i; done

