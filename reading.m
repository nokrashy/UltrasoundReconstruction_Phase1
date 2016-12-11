clc;
clear;
filename = 'G:\workshop\data folder\RF_4.5MHzCystAllFiltersOff';		
infile = fopen(filename);
while ~feof(infile)
    currData = fread(infile,'single');
    if ~isempty(currData)
        disp('"the file is opened" ')
    end
end
fclose(infile);