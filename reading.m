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
% high pass filter for cut off frequency = 2.5 MHZ using FDATOOL for getting b , a coeffs and gain.

b=[1.0000, -2.0000,1.0000]; % feedforward coeffs
a=[1.0000,-1.279632424997809         ,  0.47759225007251715              ]; % feedback coeffs
G=0.68930616876758155                                ; % section gain
bg=G*b; % pre-multiply feedforward coeffs with gain
N=size(currData,1); % 100 test samples
d=zeros(3,1); % clear delay line
output=zeros(N,1); % allocate output array
for n=1:N
    d=[0;d(1:end-1)]; % update delay line
    d(1) = currData(n)- a(2)*d(2)- a(3)*d(3); % compute feedback
    output(n) = bg(1)*d(1)+bg(2)*d(2)+bg(3)*d(3); % compute feedforward
end
%plot(x)
%% low pass filter , cut off frequency = 4.5 MHZ

b=[1.0000, 2.0000,1.0000]; 
a=[1.0000,-0.74778917825850344,0.27221493792500728]; 
Gain=0.13110643991662596 ; 
bg=Gain*b; 
d=zeros(3,1); 
finaloutput=zeros(N,1); 

for n=1:N
    d=[0;d(1:end-1)]; 
    d(1) = output(n)- a(2)*d(2)- a(3)*d(3);
    finaloutput(n) = bg(1)*d(1)+bg(2)*d(2)+bg(3)*d(3); 
end
plot(output)
plot(finaloutput)