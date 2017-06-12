%-------------*****under sampling function*****--------------
%this function convert line of data of 11688 sample to 512 sample 
%each sample is the peak of all window size samples
%input of under sampling function is      
                        %double Hilbert_out[Num of lines * Num of samples per line]; the output of hilbert function
%output of under sampling function is
                        %double sampling_out[Num of lines * Num of samples required for each line]
%each element of the output array contains 4 bytes of data after under sampling function.
function sampling_out = Under_sampling_final( input )
N_smpl=11688;
n_line=512;
window_size=N_smpl / n_line;
max=0;
j=1;
w=1;
s(1)=1;
    for k = 2 : N_smpl;
        %get round number
        l=(k/window_size)+0.5;
        s(k)=round(l);
        if(max< input(k))
           max=input(k);
        end
        if (s(k-1)== s(k))
               j=j+1;
        else 
            for i=1:j;
               j=1;
               final_output(w)=max;
            end
            w=w+1; 
            max=0;
        end        
    end
sampling_out = final_output;
end