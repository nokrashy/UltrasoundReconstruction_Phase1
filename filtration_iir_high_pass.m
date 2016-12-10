%% high pass filter for cut off frequency = 2.5 MHZ using FDATOOL for getting b , a coeffs and gain.

b=[1.0000, -2.0000,1.0000]; % feedforward coeffs
a=[1.0000,-1.279632424997809         ,  0.47759225007251715              ]; % feedback coeffs
G=0.68930616876758155                                ; % section gain
bg=G*b; % pre-multiply feedforward coeffs with gain
N=81; % 100 test samples
d=zeros(3,1); % clear delay line
output=zeros(N,1); % allocate output array
for n=1:N
    d=[0;d(1:end-1)]; % update delay line
    d(1) = input(n)- a(2)*d(2)- a(3)*d(3); % compute feedback
    output(n) = bg(1)*d(1)+bg(2)*d(2)+bg(3)*d(3); % compute feedforward
end
%plot(x)
plot(output)