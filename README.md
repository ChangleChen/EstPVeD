# Periventricular Diffusivity (PVeD) Estimation
### An automatic image analytical method to approximate the periventricular diffusivity related to glymphatic clearance integrity
--------
**Maintainer**: Chang-Le Charles Chen, chc348[at]pitt[dot]edu

**Licenses**: 
- Matlab code: MIT License

**References**: If you use, extend, or modify this method or its code, please cite/acknowledge our work by citing the associated manuscript and repository.

<div id='id-section1'/>

## About the method
This repository contains code and resources for estimating Periventricular Diffusivity (PVeD) — a diffusion MRI-based marker designed to reflect interstitial fluid dynamics in the periventricular region of the human brain, which may be associated with glymphatic integrity. Developed in the context of Alzheimer’s disease research, the PVeD metric is developed to approximate fast transverse diffusion signals aligned with deep medullary veins, offering enhanced sensitivity to amyloid accumulation and cognitive impairment.

Our method builds upon and extends the DTI-ALPS framework by:  
1. Automatically delineating periventricular regions adjacent to the lateral ventricles  

2. Quantifying voxel-wise transverse diffusion via a custom Transverse Tensor Ratio (TTR)  

3. Aggregating the signal into a robust metric (PVeD) that correlates with key Alzheimer's disease biomarkers and progression metrics  

## Software implementation
The proposed method has been implemented using Matlab. The Python version of our method is under development.
