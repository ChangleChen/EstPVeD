function fib = read_fib(file_name)
if ~exist('file_name')
    file_name =  uigetfile('*.fib.gz');
end
if file_name == 0
    image = [];
    return
end
gunzip(file_name);
[pathstr, name, ext] = fileparts(file_name);
movefile(fullfile(pathstr,name),fullfile(pathstr,strcat(name,'.mat')));
fib = load(fullfile(pathstr,strcat(name,'.mat')));
delete(fullfile(pathstr,strcat(name,'.mat')));
end