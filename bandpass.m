%-------------*****filteration function*****--------------
%this function will contain two main parts high pass and low pass filter
%each of high and low pass is infinite impulse response (IIR) butterworth second order filter
%structure of both is Direct Form II.
%sampling frequency = 50MHZ.
%high pass filter part : cut off frequency = 2.5 MHZ.
%low pass filter part : cut off frequency = 4.5 MHZ.
%function input will be data:
                             %double data[Num of lines * Num of samples per line];the output of reading function
%function output will be data:
                             %double filtered_data[Num of lines * Num of samples per line];
%each element of the output array contains 4 bytes of data after filteration.

function finaloutput=bandpass(input)
%high pass
input = input';
b=[1.0000, -2.0000,1.0000]; % feedforward coeffs
a=[1.0000,-1.5610180758007182 , 0.64135153805756306 ]; % feedback coeffs
G=0.80059240346457028       ; % section gain
bg=G*b; % pre-multiply feedforward coeffs with gain
N=size(input,2); 
d=zeros(3,1); % clear delay line
output=zeros(N,1); % allocate output array
for n=1:N
    d=[0;d(1:end-1)]; % update delay line
    d(1) = input(n)- a(2)*d(2)- a(3)*d(3); % compute feedback
    output(n) = bg(1)*d(1)+bg(2)*d(2)+bg(3)*d(3); % compute feedforward
end

%low pass
b=[1.0000,2.0000,1.0000]; % feedforward coeffs
a=[1.0000,-1.2246515810130951  , 0.45044543005604082      ]; % feedback coeffs
Gain=0.056448462260736451   ; % section gain
bg=Gain*b; % pre-multiply feedforward coeffs with gain
d=zeros(3,1); % clear delay line
finaloutput=zeros(N,1); % allocate output array
for n=1:N
    d=[0;d(1:end-1)]; % update delay line
    d(1) = output(n)- a(2)*d(2)- a(3)*d(3); % compute feedback
    finaloutput(n) = bg(1)*d(1)+bg(2)*d(2)+bg(3)*d(3); %compute feedforward
end
end

