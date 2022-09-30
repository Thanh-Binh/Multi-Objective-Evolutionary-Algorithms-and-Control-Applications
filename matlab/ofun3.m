function f=ofun3(x);
% f=ofun3(x)
% Objective function for Multiobjective Function;
% by optimization without not-strict-restrictions
%
% See also: CONT3.M


% All Rights Reserved, July 1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany


f=[x(1)^2+x(2)^2; (x(1)-5)^2+(x(2)-5)^2];

if f <= [150;150],
  f=[0;f];
else,
  f=inf;
end
%
