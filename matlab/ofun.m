function gf=ofun(x);
% gf=ofun(x)
% The objective function for the Banana function by optimization
% without not-strict restrictions
%
% See also: CONT.M

% All Rights Reserved, July 1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany


if (x(1)<=3)&(x(1)>=-3)&(x(2)<=4.5)&(x(2)>=-1.5),
   gf=[0;(100*(x(2)-x(1)^2)^2 +(x(1)-1)^2)];
else
   gf=inf;
end

