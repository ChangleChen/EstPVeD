# Periventricular Diffusivity (PVeD) Estimation
Calculate the transverse proportion of water diffusivity based on tensor elements in the periventricular areas

<div id='id-section1'/>

## Installation and Prerequisites
To use this method, please download `pkg_pved_est` and add the directory to your Matlab path
```matlab
addpath('path/to/the/folder/pkg_pved_est');
```

Prerequisites: Please download [SPM12](https://www.fil.ion.ucl.ac.uk/spm/software/spm12/) software and add to your Matlab path as well.
```matlab
addpath('path/to/the/folder/spm12');
```
The original environment for our pipeline development was using 
- MATLAB R2023a
- SPM12 (v7771)

<div id='id-section2'/>

## Diffusion MRI Data Preparation
To prepare the diffusion data for automatic PVeD calculation, please use the QSDR reconstruction with the DSI studio to reconstruct diffusion tensors. Regarding how to reconstruct the diffusion data with the QSDR, you can either use GUI (graphic user interface) or CLI (command line interface).  
For GUI instructions, please refer to [DSI studio tutorial](https://dsi-studio.labsolver.org/doc/gui_t2.html). The parameters that you need to specify include (1) choose QSDR with 2 mm output resolution, (2) choose Preprocessing to run EDDY correction (you can also preprocess your diffusion data using other tools such as `qsiprep`), (3) choose Check b-table, (4) choose No high b for DTI, (5) choose ICBM152_adult template, and (6) Other output metrics: fa,ad,rd,md,iso,rdi,nrdi,tensor. You may need to click the Advanced Options button if you can't find these on the panel. Then click Run Reconstruction.  
For CLI instructions, modify the following command line according to your filenames (`--source`) and paste it into your terminal:
`dsi_studio --action=rec --source=sub-001_dwi.src.gz --cmd="[Step T2][Corrections][EDDY]" --method=7 --param0=1.25 --other_output=all --qsdr_reso=2 --check_btable=1 --thread_count=8 --dti_no_high_b=1 --template=0 --other_output=fa,ad,rd,md,iso,rdi,nrdi,tensor`.
If you have multiple src files in the same folder, you can replace `--source=sub-001_dwi.src.gz` with `--source=*.src.gz`, and then the software can automatically get all src files in the directory. 
The version of DSI studio used for our pipeline development is the version Chen 2023-Mar (Windows OS), so to ensure the consistency of the output files, you can consider downloading this version through this [link](https://drive.google.com/file/d/1zr7qt67uF6ODTqNtakHzvSMKuBIiLLm_/view?usp=sharing).

## Estimate PVeD
To run the PVeD estimation, please refer to the `script_pved_estimation.m` script that contains step-by-step instructions.
