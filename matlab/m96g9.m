function g=m96g9(x)
% g=m96g9(x)
% EA for the solving of the Non-linear Constrained Optimization 
% This example comes from:
%    'On the Use of Non-Stationary Penalty Functions to Solve
%     Non-linear Constrained Optimization Problems with GA's'
%
%    Authors: J. Joines and C. Houck
%    North Carolina State University
% and Michalevicz 1996 Test Case 9
%
% Optimization Problem 1:
%
%     f(x)=(x(1)-10)^2 +5*(x(2)-12)^2+x(3)^4 +3*(x(4)-11)^2 +...
%          10*x(5)^6 +7*x(6)^2 +x(7)^4 -4*x(6)*x(7) -10*x(6) -8*x(7);
%
% subject to the constraints:
%     
%   127 -2*x(1)^2 -3*x(2)^4 -x(3)-4*x(4)^2 -5*x(5) >=0
%   282 -7*x(1) -3*x(2) -10*x(3)^2-x(4) +x(5) >=0
%   196 -23*x(1) -x(2)^2 -6*x(6)^2 + 8*x(7) >=0
%   -4*x(1)^2 -x(2)^2 +3*x(1)*x(2)-2*x(3)^2 -5*x(6) +11*x(7) >=0 
% and bounds: [-10 10] for all x_i
%       fmin=680.6400573



% All Rights Reserved, 05-July-1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany



epsilon=1e-7; beta=2;

if all(x >= -10*ones(1,7)) & all(x <= 10*ones(1,7))
   g=zeros(2,1);

   gcons(1) = 127 -2*x(1)^2 -3*x(2)^4 -x(3)-4*x(4)^2 -5*x(5);
   gcons(2) = 282 -7*x(1) -3*x(2) -10*x(3)^2-x(4) +x(5) ;
   gcons(3) = 196 -23*x(1) -x(2)^2 -6*x(6)^2 + 8*x(7) ;
   gcons(4) = -4*x(1)^2 -x(2)^2 +3*x(1)*x(2)-2*x(3)^2 -5*x(6) +11*x(7);

   g(1)=sum((abs(gcons).*(gcons < -epsilon)).^beta);

   g(2)=(x(1)-10)^2 +5*(x(2)-12)^2+x(3)^4 +3*(x(4)-11)^2 +...
      10*x(5)^6 +7*x(6)^2 +x(7)^4 -4*x(6)*x(7) -10*x(6) -8*x(7);
else,
   g=inf;
end  

