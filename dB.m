function y = dB( x, dBrange )
%DB     convert an array to decibels
%--         
%  Usage:   Y = dB( X, dbRANGE, dbMAX )
%
%          will compute 20 Log(X)
%          and then scale or clip the result so that
%          the minimum dB level is dbMAX-dbRANGE.
%          ex: db(X, 80, 0) gives the range 0 to -80 dB
%
%      Y = dB( X, dbRANGE ) defaults to dBmax = 0
%---------------------------------------------------------------
% copyright 1994, by C.S. Burrus, J.H. McClellan, A.V. Oppenheim,
% T.W. Parks, R.W. Schafer, & H.W. Schussler.  For use with the book
% "Computer-Based Exercises for Signal Processing Using MATLAB"
% (Prentice-Hall, 1994).
%---------------------------------------------------------------
dBmax = 150;
if dBrange<=0
   error(' min dB is max dB minus dBrange')
end
y = abs(x);
ymax = max(y)/10.0^(dBmax/20);
y = y/ymax;
thresh = 10.0^((dBmax-dBrange)/20);
y = y.*(y>thresh) + thresh.*(y<=thresh);
y = 20.0*log10(y);