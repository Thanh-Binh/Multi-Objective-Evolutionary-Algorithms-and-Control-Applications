function gf=ofun1(x);
% gf=ofun1(x)
% Objective function for Six Hump Camel Back Function
% by optimization without not-strict-restrictions
%
% See also: CONT1.M

% All Rights Reserved, 04-July-96  
% To Thanh Binh IFAT Uni. of Magdeburg Germany

if (abs(x(1))<=2.5)&(abs(x(2))<=1.5),
  gf=[0;4*x(1)^2-2.1*x(1)^4+x(1)^6/3+x(1)*x(2)-4*x(2)^2+4*x(2)^4+1.1];
else,
  gf=inf;
end 
%
