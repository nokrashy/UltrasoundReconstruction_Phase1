%-------------*****reading function*****--------------
% its name "read_bin_file" , this function will read binary data from file.
%binary data file contains Num of lines= 256 line each line includes  Num of samples per line 11688 sample each
%sample express float type = 4 byte. 
%its input will be:
%file name : char[]={"RF_4.5MHzCystAllFiltersOff"}; 
%data type : char[]={"single"};
%its output will be : double data[Num of lines * Num of samples per line];
%each element of the output array contains 4 bytes of data.

function [a] = read_bin_file( filename , data_type ) 
fid=fopen(filename,'r');
if fid<0
    error('error opening file %s \n',filename);
end
a=fread(fid , inf , data_type);
fclose(fid);
end

