#!/bin/bash

# Prerequisite: install FSL-MRS according to the instructions on their website

maindir=
scriptsdir=
basisset= # <---- fill in basisset

cd $datadir

for i in * ;do  # <---- fill in which subjects

# run additional spectral registration step in FSL-MRS
python $scriptsdir/helper/2_dynamic_align.py $maindir/$i/data_specreg $basisset $maindir/$i
done

#run first level dynamic analysis in FSL-MRS (change name of config file and design file for specific analysis 
for i in * ; do #
fsl_dynmrs --data $maindir/"$i"/data_specreg_aligned.nii.gz \
--basis $basisset \
--output $maindir/"$i"/outputname \
--dyn_config $scriptsdir/helper/config_file.py \
--time_variables $maindir/design.csv \
--metab_groups MM_CMR --report --verbose
done

#run second level analysis (change file list of first level,  the contrast file , design.mat and design.con for specific analysis and dataset)
fmrs_stats --data $maindir/filelist_of_first_level.txt --output $maindir/second_level_output_name --fl-contrasts $maindir/scripts/final_scripts/helper/first_level_contrasts.json --hl-design $scriptsdir/design_hl.mat --hl-contrasts $scriptsdir/design_hl.con --combine NAA NAAG --combine Cr PCr --combine Glu Gln --combine PCh GPC --combine Tau Glc --verbose --report
