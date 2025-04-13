function pved_est(dir_fib,dir_pkg)
fprintf('PVeD Estimation: Start...\n')
fn = dir(fullfile(dir_fib,"*.fib.gz")); fn = {fn.name}';
pved_index = zeros(numel(fn),3);
qa_vec = zeros(numel(fn),1);
for inx = 1:numel(fn)
    % load fib files and extract mean diffusivity maps from the files
    tic;
    extract_md_from_fib(fullfile(dir_fib,fn{inx}))
    fib = read_fib(fullfile(dir_fib,fn{inx}));
    index_txx = fib.txx;
    index_tyy = fib.tyy;
    index_tzz = fib.tzz;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculate ratio
    fprintf('        Ratio calculation\n');
    index_ratio = index_txx./sqrt(index_txx.^2 + index_tyy.^2 + index_tzz.^2);
    index_ratio(isinf(index_ratio)) = 0; index_ratio(isnan(index_ratio)) = 0;
    index_ratio = reshape(index_ratio, fib.dimension);

    if fib.dimension(1) ~=78 || fib.dimension(2) ~= 94 || fib.dimension(3) ~=68
        index_ratio = imresize3(index_ratio,[78,94,68]);
    end

    % Quality assurance for Dxx axis
    qa_region = index_ratio(26:55,26:70,37:39); % This is hard-coded; please modify as needed.
    qa_region = reshape(qa_region,1,numel(qa_region));
    qa_vec(inx,1) = mean(qa_region);

    % generate initial masks
    fprintf('        Initial mask creation\n');
    fn_md = [fn{inx},'.md.nii'];
    map_name1 = ['csf_mask_',fn_md];
    if ~isfile(fullfile(dir_fib,map_name1))
        pvs_spm_seg(fullfile(dir_fib,fn_md));
    end
    fn_lv_mask = ['lv_mask_',fn_md];
    if ~isfile(fullfile(dir_fib,fn_lv_mask))
        pvs_spm_coreg(fn_md,dir_fib,dir_pkg);
        movefile(fullfile(dir_fib,'rICBM152_adult_lv_mask.nii'),fullfile(dir_fib,fn_lv_mask));
    end

    % create PVR masks
    hdr = spm_vol(fullfile(dir_fib,fn_lv_mask)); % header
    lv_posterior_bw = spm_read_vols(hdr); % image
    lv_posterior_bw(lv_posterior_bw>0.1) = 1; lv_posterior_bw(lv_posterior_bw~=1) = 0;
    pvr_mask = create_pvr_mask_adapt(lv_posterior_bw);
    if size(pvr_mask,1) ~=78 || size(pvr_mask,2) ~= 94 || size(pvr_mask,3) ~=68
        pvr_mask = imresize3(pvr_mask,[78,94,68]);
    end
    pvr_mask(pvr_mask==0) = NaN;

    % generate final masks
    fprintf('        Final mask creation\n');
    hdr = spm_vol(fullfile(dir_fib,['csf_mask_',fn_md])); % header
    csf_posterior_bw = spm_read_vols(hdr); % image
    csf_posterior_bw(csf_posterior_bw>0.1) = 1; csf_posterior_bw(csf_posterior_bw~=1) = 0;
    csf_posterior_bw = abs(csf_posterior_bw-1);
    if size(csf_posterior_bw,1) ~=78 || size(csf_posterior_bw,2) ~= 94 || size(csf_posterior_bw,3) ~=68
        csf_posterior_bw = imresize3(csf_posterior_bw,[78,94,68]);
    end
    csf_posterior_bw(csf_posterior_bw==0) = NaN;
    pvr_mask_final = pvr_mask.*csf_posterior_bw;

    % sampling
    index_ratio_sample = index_ratio.*pvr_mask_final;

    hdr.fname = strrep(hdr.fname,['csf_mask_',fn_md],['final_pvs_',fn_md]);
    spm_write_vol(hdr,pvr_mask_final);
    hdr.fname = strrep(hdr.fname,['final_pvs_',fn_md],['ttr_',fn_md]);
    hdr.dt = [16,0];
    spm_write_vol(hdr,index_ratio);

    % top -> right
    index_ratio_l = index_ratio_sample(round(size(index_ratio_sample,1)/2)+1:end,:,:);
    index_ratio_l = reshape(index_ratio_l,1,numel(index_ratio_l));
    pved_index(inx,1) = median(index_ratio_l,'omitmissing');

    index_ratio_r = index_ratio_sample(1:round(size(index_ratio_sample,1)/2),:,:);
    index_ratio_r = reshape(index_ratio_r,1,numel(index_ratio_r));
    pved_index(inx,2) = median(index_ratio_r,'omitmissing');

    index_ratio_all = reshape(index_ratio_sample,1,numel(index_ratio_sample));
    pved_index(inx,3) = median(index_ratio_all,'omitmissing');
    toc;
    fprintf('Sub: %g\n',inx)
    
end

% create table
tb_fn = cell2table(fn,'VariableNames',{'image_id'});
tb_pved = array2table([pved_index,qa_vec],'VariableNames',{'PVeD_L','PVeD_R','PVeD_total','QA_index'});
tb_final = [tb_fn,tb_pved];
writetable(tb_final,fullfile(dir_fib,'PVeD_metrics.csv'));