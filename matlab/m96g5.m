function g=m96g5(x);
% g=m96g5(x);
% Test Case #5 of Michalevicz 1996
%   'Evolutionary Algorithms for Constrainted Parameter Optimization Prob.'
%
% Objective function:
%        f(x) = 3*x(1) +1e-6*x(1)^3 +2*x(2) +1e-6*2/(3*x(2)^3)
% subject to  non-linear constraints:
%   x(4)-x(3)+.55 >=0
%   x(3)-x(4)+.55 >=0
%   1000*sin(-x(3)-.25)+1000*sin(-x(4)-.25)+894.8-x(1)    =0
%   1000*sin(x(3)-.25)+1000*sin(x(3)-x(4)-.25)+894.8-x(2) =0
%   1000*sin(x(4)-.25)+1000*sin(x(4)-x(3)-.25)+1294.8     =0
% and bounds
%        0 <= x(1:2) <= 1200; abs(x(3:4)) <=.55
% fmin=5126.4981 at (679.9453 1026.067 .118876 -.3962336)


% All Rights Reserved, 01 August 1996
% To Thanh Binh , IFAT University of Magdeburg Germany


epsilon=1e-4; beta=2;

if all(x(1:2)<=1200)& all(x(1:2) >= 0) & all(abs(x(3:4)) <=.55), 

  g=zeros(2,1);
  gcons1(1)=x(4)-x(3)+.55;
  gcons1(2)=x(3)-x(4)+.55;
  g(1)=sum((abs(gcons1).*(gcons1 < -epsilon)).^beta);
  gcons2(1)=1000*sin(-x(3)-.25)+1000*sin(-x(4)-.25)+894.8-x(1);
  gcons2(2)= 1000*sin(x(3)-.25)+1000*sin(x(3)-x(4)-.25)+894.8-x(2);
  gcons2(3)= 1000*sin(x(4)-.25)+1000*sin(x(4)-x(3)-.25)+1294.8;
  gcons2=abs(gcons2);
  g(1)=g(1)+sum((gcons2.*(gcons2 > epsilon)).^beta);
  g(2)= 3*x(1) +1e-6*x(1)^3 +2*x(2) +1e-6*2/(3*x(2)^3);

else,
  g=inf;  
end
%
