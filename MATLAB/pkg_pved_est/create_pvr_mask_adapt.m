function pvr_mask = create_pvr_mask_adapt(lv_posterior_bw)
pvr_mask = zeros(size(lv_posterior_bw));
lv_weight = sum(squeeze(sum(lv_posterior_bw,1)),1);
lv_weight = (lv_weight-min(lv_weight))/(max(lv_weight)-min(lv_weight));
lv_weight = lv_weight.^0.3;
inx = find(lv_weight>0);
midpoint = round(min(inx)+(length(inx)/2));
x = linspace(-4,4,length(inx))+midpoint;
y = 1./(1+exp(-2*(x-midpoint)));
temp_vec = zeros(size(lv_weight));
temp_vec(inx)=y;
lv_weight = lv_weight.*temp_vec;

lv_weight_y = sum(squeeze(sum(lv_posterior_bw,1)),2);
lv_weight_y = (lv_weight_y-min(lv_weight_y))/(max(lv_weight_y)-min(lv_weight_y));
lv_weight_y = imgaussfilt(lv_weight_y,2);
[~,locs] = findpeaks(lv_weight_y);
vec_y = zeros(size(lv_weight_y));
vec_y(locs(1):locs(2)) = 1;
vec_y = imgaussfilt(vec_y,5);

lv_bound = squeeze(max(lv_posterior_bw,[],2));
lv_bound = sum(lv_bound,1); lv_bound(lv_bound~=0) = 1; lv_bound = sum(lv_bound);
max_dila = lv_bound;
dim_x = size(lv_posterior_bw,1);
for z = 1:size(lv_posterior_bw,3)
    slice = lv_posterior_bw(:,:,z);
    if sum(slice,"all")>0
        slice_dila = zeros(size(slice));

        for y = 1:length(lv_weight_y)
            temp_vec = slice(:,y);
            
            se = strel('line',max_dila*(lv_weight(z)^3)*vec_y(y),90);
            slice_dila(:,y) = imdilate(temp_vec,se);
        end
  
        te_top = slice(1:round(dim_x/2),:);
        te_bot = slice(round(dim_x/2)+1:end,:);
        fil_te1 = abs(te_top-1);
        fil_te2 = abs(te_bot-1);
        for i=1:size(te_top,1)
            if i>1
                fil_te2(i,:) = fil_te2(i,:).*fil_te2(i-1,:);
            end
            k = round(dim_x/2)+1-i;
            if k<round(dim_x/2)
                fil_te1(k,:) = fil_te1(k,:).*fil_te1(k+1,:);
            end
        end
        fil_te = [fil_te1;fil_te2]; fil_te = abs(fil_te-1);
        slice = abs(slice-1);
        slice = fil_te.*slice_dila.*slice;
    end
    pvr_mask(:,:,z) = slice;
end
pvr_mask(isinf(pvr_mask)) = 0; pvr_mask(isnan(pvr_mask)) = 0;
end