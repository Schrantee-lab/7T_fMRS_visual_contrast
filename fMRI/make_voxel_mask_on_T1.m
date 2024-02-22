%% script to register voxel from SDAT/SPAR format to nifti using Gannet
clear all

% add paths of Gannet (2.0) and SPM, vax_io, parrec and dicomtools

main_dir=pwd;
cd(main_dir)

t1_name=dir(fullfile(main_dir,'*.nii'))
file_name=dir(fullfile(main_dir,'*.SPAR'))
GannetMask_Philips((file_name.name),(t1_name.name));
