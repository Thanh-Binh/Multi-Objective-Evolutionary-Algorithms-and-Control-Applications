function f=ofun4(x)
% f=ofun4(x)
% The objective function of the Griewangk-Function
% by optimization without not-strict-restrictions
%
% See also: CONT4.M

% All Rights Reserved, July 1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany

k=100;
if all(abs(x)<= 50*k),
   f=[0;(x(1)^2+x(2)^2)/4000-cos(x(1))*cos(x(2)/sqrt(2))+1];
else,
   f=inf;
end

