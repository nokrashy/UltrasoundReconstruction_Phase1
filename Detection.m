%-------------*****Detection function*****--------------
%its name "Detection", this function will make detection for the signal.
%producing shifted signal( which out of phase 90 degree)with using FIR. 
%hilbert = the absolute of ( orignal signal + shifted signal).
%input of Detection function is      
                        %double filtered_data[Num of lines * Num of samples per line]which is the output of bandpass function
%output of Detection function is
                        %double Hilbert_out[Num of lines * Num of samples per line]
%each element of the output array contains 4 bytes of data after Detection function.

function D_out = Detection( input )
order = 2;
n_freq = 1/25; % fs = 50MHZ , Nyq = 25MHZ , f = 1MHZ , n_freq = f/NYQ;
N = 20;           % Order of filter
F = [0.05 0.95];  % Frequency Vector
A = [1 1];        % Amplitude Vector
W = 1;            % Weight Vector
b100  = firpm(N, F, A, W, 'hilbert');   %Hilbert order 100
SSum90 = filter(b100,1,input);
SSumD = sqrt((SSum90.*SSum90)+(input.*input));
[b a]=butter(order,n_freq,'low');
LPF_SSumD = filter(b,a,SSumD);
D_out = LPF_SSumD;
end