function [ sampling_out ] = normal( input )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
N_smpl=11688;
n_line=512;
window_size=N_smpl / n_line;
j=1;
w=1;
s(1)=1;
    for k = 2 : N_smpl;
        %get round number
        l=(k/window_size)+0.5;
        s(k)=round(l);
        value=input(k);
           
        if (s(k-1)== s(k))
               j=j+1;
           else           
               final_output(w)=value;
               j=1;
               w=w+1; 
        end        
    end
sampling_out = final_output;

end

