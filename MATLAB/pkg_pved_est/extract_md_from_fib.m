function extract_md_from_fib(file_name)
% input filename should be in full directory
fib = read_fib(file_name);
md_img = reshape(fib.md,fib.dimension);
fname = [file_name,'.md.nii'];
mat = fib.trans'; sclvec = sign([mat(1,1);mat(2,2);mat(3,3)]);
mat(1:3,end) = mat(1:3,end) + fib.voxel_size'.*-sclvec;
mat0 = zeros(4);
mat0(1,1) = -fib.voxel_size(1);
mat0(2,2) = fib.voxel_size(2);
mat0(3,3) = fib.voxel_size(3);
mat0(4,4) = 1;
mat0(1:3,end) = [fib.dimension(1)+1;-(fib.dimension(2)+1);-(fib.dimension(3)+1)];

% create header
h.fname = fname;
h.dim = fib.dimension;
h.dt = [16,0];
h.pinfo = [1;0;352];
h.mat = mat;
h.mat0 = mat0;
h.n = [1,1];
h.descrip = 'NIFTI-1 MD';

h.private.dat = file_array(fname,fib.dimension,'FLOAT32-LE',352,1,0,'rw');
h.private.mat = mat;
h.private.mat_intent = 'MNI152';
h.private.mat0 = mat0;
h.private.timing.toffset = 0;
h.private.timing.tspace = 1;

spm_write_vol(h,md_img);
end