function pvs_spm_coreg(fn_md,mp,tp)
copyfile(fullfile(tp,'ICBM152_adult_lv_mask.nii'),fullfile(tp,'ccICBM152_adult_lv_mask.nii'));
matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {fullfile(mp,fn_md)};
matlabbatch{1}.spm.spatial.coreg.estwrite.source = {fullfile(tp,'ccICBM152_adult_lv_mask.nii,1')};
matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
spm_jobman('run',matlabbatch);
delete(fullfile(tp,'ccICBM152_adult_lv_mask.nii'))
movefile(fullfile(tp,'rccICBM152_adult_lv_mask.nii'),fullfile(mp,'rICBM152_adult_lv_mask.nii'));
end
