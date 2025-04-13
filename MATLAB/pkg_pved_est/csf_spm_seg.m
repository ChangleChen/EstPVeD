function csf_spm_seg(fn_md)
csf_spm_seg_job(fn_md);
hdr = spm_vol(['c1',fn_md]); % header
img_c = spm_read_vols(hdr); % image
hdr = spm_vol(['c2',fn_md]); % header
img_c = spm_read_vols(hdr) + img_c; % image
hdr = spm_vol(['c4',fn_md]); % header
img_c = spm_read_vols(hdr) + img_c; % image
hdr = spm_vol(['c5',fn_md]); % header
img_c = spm_read_vols(hdr) + img_c; % image
hdr = spm_vol(['c6',fn_md]); % header
img_c = spm_read_vols(hdr) + img_c; % image
hdr.fname = strrep(hdr.fname,['c6',fn_md],['outer_csf_mask_',fn_md]);
spm_write_vol(hdr,img_c);
delete(['c1',fn_md]);
delete(['c2',fn_md]);
delete(['c4',fn_md]);
delete(['c5',fn_md]);
delete(['c6',fn_md]);
end