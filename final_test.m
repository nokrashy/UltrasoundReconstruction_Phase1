line_size = 11688;
n_lines = 256;
line_req = 512;
order = 2;
n_freq = 1/25; % fs = 50MHZ , Nyq = 25MHZ , f = 1MHZ , n_freq = f/NYQ;
data=read_bin_file('RF_4.5MHzCystAllFiltersOff', 'single');
filtered_data=bandpass(data);
Hilbert_out = HLBRT (filtered_data);
[b a]=butter(order,n_freq,'low');
LPF_Hilbert_out = filter(b,a,Hilbert_out);
line_window=1:line_size:line_size*n_lines;
samplin_window=1:line_req:line_req*n_lines;
for i = 1 : n_lines;
    under_sampling_data(samplin_window(i):line_req+samplin_window(i)-1)= Under_sampling_final(LPF_Hilbert_out(line_window(i):line_size+line_window(i)-1));
end
pre_final_image = reshape(under_sampling_data , 512 , 256);
pre_final_image = mat2gray(pre_final_image);
final_image = log_transformation (pre_final_image);
imshow(final_image);