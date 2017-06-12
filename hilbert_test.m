function finaloutput=hilbert_test(input)

x=input;
order = 20;
b=firpm(order,[0.05 0.95],[1 1],1,'hilbert');
%-------- fir filter ---------------%
p = 0;
z = zeros(size(b));
y = zeros(size(x));
nx = length(x);
nb = length(b);
for n=1:nx
   p=p+1; 
   if p>nb
       p=1;
   end
   z(p) = x(n);
   acc = 0;
   k = p;
   for j=1:nb
      acc = acc + b(j)*z(k);
      k=k-1; 
      if k<1
          k=nb; 
      end
   end
   y(n) = acc;
end
z=sqrt(x.*x + y .* y);
%------low pass filter ---------
b=[1.0000,2.0000,1.0000]; % feedforward coeffs
a=[1.0000,-1.8226949251963083         ,  0.83718165125602262            ]; % feedback coeffs
Gain=0.0036216815149286421        ; % section gain
bg=Gain*b; % pre-multiply feedforward coeffs with gain
d=zeros(3,1); % clear delay line
v=z';
N=size(v,2);
finaloutput=zeros(N,1); % allocate output array
for n=1:N
    d=[0;d(1:end-1)]; % update delay line
    d(1) = v(n)- a(2)*d(2)- a(3)*d(3); % compute feedback
    finaloutput(n) = bg(1)*d(1)+bg(2)*d(2)+bg(3)*d(3); %compute feedforward
end
end