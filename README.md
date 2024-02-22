# 7T_fMRS_visual_contrast
This folder contains all code associated with the manuscript of Schrantee et al. (2023), which was published in Imaging Neuroscience. 
You can find this manuscript here: https://doi.org/10.1162/imag_a_00031

It was previously published as a preprint, which can be found here: https://doi.org/10.1162/imag_a_00031

# Main batch scripts and file descriptions
For the fMRI analysis: 
- fMRI_loop.sh: bash script that loops over fMRI_analysis.sh
- fMRI_analysis.sh: bash script that runs fMRI analysis and extracts data from the MRS voxel location. 

For the fMRS analysis: 

Data are preprocessed in matlab, exported as mat files and then converted to nifti MRS format (https://doi.org/10.1002/mrm.29418). The scripts provided start here, and data need to be saved as individual transients. 
- preproc_first_second_levels.sh: contains dynamic alignment step, first level dynamic analysis and second level analysis as implemented in FSL-MRS.
- The first level analysis needs additional input for which these scripts were used:
  - makedesign_*.py: design matrices are needed, which are created here
  - config_file*.py: defines the model parameters
  - first_level_contrasts.json: contains the contrasts run at first level
- extracted MRS traces: extract_glu_init_trace.m (and the loop around it) can be run after FSL-MRS to inspect the neurometabolite traces based on initial fits. 
