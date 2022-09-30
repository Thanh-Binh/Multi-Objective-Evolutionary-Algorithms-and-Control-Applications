function g=m96g10(x)
% g=m96g10(x)
% EA for the solving of the Non-linear Constrained Optimization 
% This example comes from:
%    'On the Use of Non-Stationary Penalty Functions to Solve
%     Non-linear Constrained Optimization Problems with GA's'
%
%    Authors: J. Joines and C. Houck
%    North Carolina State University
%
% as Optimization Problem 4,
% and it is test case 10 of Michalevicz
%
%     f(x)=x(1)+x(2)+x(3);
%
% subject to the constraints:
%     
%   1 -.0025*x(4) -.0025*x(6)                                        >=0
%   1 -.0025*x(5) -.0025*x(7) +.0025*x(4)                            >=0
%   1 -.01*x(8) +.01*x(5)                                            >=0
%   x(1)*x(6)-833.33252*x(4) - 100*x(1) + 83333.333  >=0
%   x(2)*x(7)-1250*x(5) - x(2)*x(4) + 1250*x(4)      >=0
%   x(3)*x(8)-1250000 - x(3)*x(5) + 2500*x(5)        >=0
%
% and bounds:  100<=x(1)<=10000;
%              1000<=x(i)<=10000, (i=2,3)
%              10 <=x(j)<=1000  (j=4,5,6,7,8)
%
%     fmin=7049.3309


% All Rights Reserved, 05-July-1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany



epsilon=1e-7; beta=2;
upper=[10000 10000 10000 1000 1000 1000 1000 1000];
lower=[100   1000  1000  10   10   10   10   10];

if all(x<=upper) &all(x>=lower),
   g=zeros(2,1);
   gcons(1)= 1 -.0025*x(4) -.0025*x(6);
   gcons(2)= 1 -.0025*x(5) -.0025*x(7) +.0025*x(4);
   gcons(3)= 1 -.01*x(8) +.01*x(5);
   gcons(4)= x(1)*x(6)-833.33252*x(4) - 100*x(1) + 83333.333;
   gcons(5)= x(2)*x(7)-1250*x(5) - x(2)*x(4) + 1250*x(4);
   gcons(6)= x(3)*x(8)-1250000 - x(3)*x(5) + 2500*x(5); 

   g(1)=sum((abs(gcons).*(gcons < -epsilon)).^beta);
   g(2)=x(1)+x(2)+x(3);
else
   g=inf;
end
  
