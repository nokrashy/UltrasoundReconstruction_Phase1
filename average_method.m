function  sampling_out  = average_method( input )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N_smpl=11688;
n_line=512;
window_size=N_smpl / n_line;
sum=0;
j=1;
w=1;
s(1)=1;
    for k = 2 : N_smpl;
        %get round number
        l=(k/window_size)+0.5;
        s(k)=round(l);
        sum=sum+input(k);   
        if (s(k-1)== s(k))
               j=j+1;
           else 
               avrg=sum/j;
               final_output(w)=avrg;
               j=1;
               w=w+1; 
               sum=0;
        end        
    end
sampling_out = final_output;

end

