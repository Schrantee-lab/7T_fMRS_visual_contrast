#!/bin/bash

# Anouk Schrantee 2023
# This script analyses fMRI data that were obtained simultaneously with fMRS data

# Input required is the dir containing the following data:
# T1 in nifti format
# fMRI in nifti format
# spectroscopy in SDAT/SPAR format

# Programs required:
# FSL needs to be installed
# Matlab needs to be installed with:
# SPM12
# Gannet (2.0 used here): https://markmikkelsen.github.io/Gannet-docs/
# vax_io, parrec and dicomtools toolboxes


# call this script: sh fMRI_analysis.sh subject_dir

#define directories
DATA_DIR=${1}

maindir=  # enter the directory with the subject folders

cd $DATA_DIR

#which Subject
pp=`echo $DATA_DIR | cut -f7 -d"/"`

####################################
# anatomical images and spectro voxel
####################################

# calls matlab to register spectro voxel to T1
   cp $maindir/make_voxel_mask_on_T1_1.m $DATA_DIR
   matlab -nodisplay -nosplash -nodesktop -r "run('$DATA_DIR/make_voxel_mask_on_T1.m');exit"
   rm -f $DATA_DIR/make_voxel_mask_on_T1_1.m
   mv *mask.nii $DATA_DIR/voxel_in_T1.nii
   pigz $DATA_DIR/*.nii

####################################
# run functional analyses
####################################

 cp $maindir/design_type3.fsf $DATA_DIR
 sed -i -e 's/CHANGEPP/'$pp'/g' $DATA_DIR/design_type3.fsf
 feat $DATA_DIR/design_type3.fsf

 #run feat  without smoothing
 cp $maindir/preproc_design3.fsf $DATA_DIR
 sed -i -e 's/CHANGEPP/'$pp'/g' $DATA_DIR/preproc_design3.fsf
 feat $DATA_DIR/preproc_design3.fsf

####################################
# extract timecourse from spectro voxel
####################################

# reslice voxel to fMRI space and extract time course
flirt -in $DATA_DIR/voxel_in_T1.nii.gz -ref $DATA_DIR/preproc.feat/mean_func \
-out $DATA_DIR/voxel_in_fMRI.nii.gz -init $DATA_DIR/preproc.feat/reg/highres2example_func.mat \
-applyxfm -interp nearestneighbour
fslmeants -i $DATA_DIR/preproc.feat/filtered_func_data.nii.gz -o $DATA_DIR/timecourse_within_spectro_voxel_$pp.txt \
-m $DATA_DIR/voxel_in_fMRI.nii.gz

####################################
# extract statistics from within voxel
####################################

#calculate percentage change
featquery 1 $DATA_DIR/fMRI_spectro.feat 5 stats/pe1 stats/pe2 stats/cope1 stats/cope2 stats/cope3 featquery_beta $DATA_DIR/voxel_in_fMRI.nii.gz
perc_change_10=`cat $maindir/"$pp"/fMRI_spectro.feat/featquery_beta/report.txt | grep stats/cope1 | awk '{print $6}'`   #extract the mean from the featquery output
perc_change_100=`cat $maindir/"$pp"/fMRI_spectro.feat/featquery_beta/report.txt | grep stats/cope2 | awk '{print $6}'`   
perc_change_100vs10=`cat $maindir/"$pp"/fMRI_spectro.feat/featquery_beta/report.txt | grep stats/cope3 | awk '{print $6}'`   
echo "$pp"",""$perc_change_10"",""$perc_change_100"",""$perc_change_100vs10""," >> $maindir/featquery_beta.csv
