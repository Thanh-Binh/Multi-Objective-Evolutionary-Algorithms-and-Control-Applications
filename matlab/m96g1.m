function g=m96g1(x)
% g=m96g1(x)
% EA for the solving of the Non-linear Constrained Optimization 
% This example comes from Test Case #1 of Michalevicz 96
%   'Evolutionary Algorithms for Constrainted Parameter Optimization Prob.'
%
% Optimization Problem 1:
%
%     f(x)=5*sum(x(1:4)) -5*sum(x(1:4).^2) -sum(x(5:13));
%
% subject to the constraints:
%     
%    2*(x(1)+x(2)) + x(10)+x(11) -10 <=0;
%    2*(x(1)+x(3)) + x(10)+x(12) -10 <=0;
%    2*(x(2)+x(3)) + x(11)+x(12) -10 <=0;
%    -8*x(1)+x(10)                   <=0;
%    -8*x(2)+x(11)                   <=0;
%    -8*x(3)+x(12)                   <=0;
%    -2*x(4)-x(5) +x(10)             <=0;
%    -2*x(6)-x(7) +x(11)             <=0;
%    -2*x(8)-x(9) +x(12)             <=0;
% and the bounds:
%    0 <= x(i) <=1;   i=1:9 and 13
%    0 <= x(j) <=100; j=10,11,12
%
% global solution is [ones(1,9),3,3,3,1] and fmin=-15; 


% All Rights Reserved, 05-July-1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany



epsilon=1e-7; beta=2;

if (all(x) >=0)&(all(x([1:9,13])) <=1)&(all(x([10 11 12])) <= 100),

   g=zeros(2,1);
   gcons(1)= 2*(x(1)+x(2)) + x(10)+x(11) -10;
   gcons(2)= 2*(x(1)+x(3)) + x(10)+x(12) -10;
   gcons(3)= 2*(x(2)+x(3)) + x(11)+x(12) -10;
   gcons(4)= -8*x(1)+x(10)                  ; 
   gcons(5)= -8*x(2)+x(11)                  ;
   gcons(6)= -8*x(3)+x(12)                  ;
   gcons(7)= -2*x(4)-x(5) +x(10)            ;
   gcons(8)= -2*x(6)-x(7) +x(11)            ;
   gcons(9)= -2*x(8)-x(9) +x(12)            ;

   g(1)=sum((abs(gcons).*(gcons > epsilon)).^beta);
  
   g(2)=5*sum(x(1:4)) -5*sum(x(1:4).^2) -sum(x(5:13));
else,
   g=inf;
end
  
