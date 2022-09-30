function g=michal3(x);
% g=michal3(x);
% Test Case #1 of Michalevicz 1994
%   'Evolutionary optimization of constrained problems'
%
%   Proceeding of the 3rd Annual Conference on Evolutionary Programming
%   A.V. Sebald and L.J. Fogel, World Scientific Publishing, River Edge,
%   NJ, 1994, pp. 98--108
%
% Objective function:
%        f(x) = .01*x(1)^2 +x(2)^2
% subject to  non-linear constraints:
%        x(1)*x(2) -25 >=0
%        x(1)^2 + x(2)^2 -25 >=0
% !!!!!!!!! the 2nd constraints can not be considered
% and bounds
%        2 <= x(1) <= 50; 0 <= x(2) <=50
%
% Global solution is (sqrt(250),sqrt(2.5))=(15.811388, 1.581139),
% fmin=5
% the starting feasible point (2,2) 


% All Rights Reserved, 04 July 1996
% To Thanh Binh , IFAT University of Magdeburg Germany


epsilon=1e-7; beta=2;

if (x(1)<=50)&(x(1) >= 2)&(x(2)<=50)&(x(2) >=0), 

  g=zeros(2,1);
  gcons(1)= x(1)*x(2) -25 ;
  gcons(2)= x(1)^2 + x(2)^2 -25 ;
  g(1)=sum((abs(gcons).*(gcons < -epsilon)).^beta);
  g(2)=.01*x(1)^2 +x(2)^2;

else,
  g=inf;  
end
%
