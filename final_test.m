line_size = 11688;
n_lines = 256;
line_req = 512;
row_pixel=512;
coloumn_pixel=512;
nLines=256;
lens=0.7;
R = 61;     %probe radius in mm
pitch = 0.2;
depth = 180.0;  % mm
data=read_bin_file('RF_4.5MHzCystAllFiltersOff', 'single');
filtered_data=bandpass(data);
Detection_out = Detection (filtered_data);
line_window=1:line_size:line_size*n_lines;
samplin_window=1:line_req:line_req*n_lines;
for i = 1 : n_lines;
    under_sampling_data(samplin_window(i):line_req+samplin_window(i)-1)= Under_sampling_final(Detection_out(line_window(i):line_size+line_window(i)-1));
%     under_sampling_data1(samplin_window(i):line_req+samplin_window(i)-1)= normal(Detection_out(line_window(i):line_size+line_window(i)-1));
%     under_sampling_data2(samplin_window(i):line_req+samplin_window(i)-1)= average_method(Detection_out(line_window(i):line_size+line_window(i)-1));
end
image_t = dB( under_sampling_data, 60);
final_image = reshape(image_t , 512 , 256);
LOOK_UP_TABLE=scanconverter(R,pitch,depth,lens,nLines);
final_image=mat2gray(final_image);
LOOK_UP_TABLE_design;