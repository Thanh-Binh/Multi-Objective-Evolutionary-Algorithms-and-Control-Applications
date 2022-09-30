function g=michal2(x);
% g=michal2(x);
% Test Case #2 of Michalevicz 1994
%   'Evolutionary optimization of constrained problems'
%
%   Proceeding of the 3rd Annual Conference on Evolutionary Programming
%   A.V. Sebald and L.J. Fogel, World Scientific Publishing, River Edge,
%   NJ, 1994, pp. 98--108
%
% Objective function:
%        f(x) = -x(1)-x(2)
% subject to  non-linear constraints:
%        2*x(1)^4 -8*x(1)^3 +8*x(1)^2 +2 -x(2) >=0
%        4*x(1)^4 -32*x(1)^3 +88*x(1)^2 -96*x(1)+36 -x(2) >=0
% and bounds
%        0 <= x(1) <= 3; 0 <= x(2) <=4
%
% Global solution is (2.3295,3.1783), fmin=-5.5079
% the starting feasible point (0 0) 
% Property of the feasible region: almost disconnected


% All Rights Reserved, 04 July 1996
% To Thanh Binh , IFAT University of Magdeburg Germany


epsilon=1e-7; beta=2;

if (x(1)<=3)&(x(1) >= 0)&(x(2)<=4)&(x(2) >=0), 

  g=zeros(2,1);
  g(2)=-x(2)-x(1);
  gcons(1)= 2*x(1)^4 -8*x(1)^3 +8*x(1)^2 +2 -x(2) ;
  gcons(2)= 4*x(1)^4 -32*x(1)^3 +88*x(1)^2 -96*x(1)+36 -x(2) ;
  g(1)=sum((abs(gcons).*(gcons < -epsilon)).^beta);

else,
  g=inf;  
end
%
