function g=m96g8(x);
% g=m96g8(x);
% Test Case #8 of Michalevicz 1996
%   'Evolutionary Algorithms for Constrainted Parameter Optimization Prob.'
%
%   Proceeding of the 3rd Annual Conference on Evolutionary Programming
%   A.V. Sebald and L.J. Fogel, World Scientific Publishing, River Edge,
%   NJ, 1994, pp. 98--108
%
% Objective function:
%        f(x) = -sin(2*pi*x(1))^3 *sin(2*pi*x(2)) /(sum(x)* (x(1)^3))
% subject to  non-linear constraints:
%        x(1)^2 -x(2) +1 <=0
%        1-x(1)+(x(2)-4)^2 <=0
% and bounds
%        0 <= x <= 10;
%


% All Rights Reserved, 01 August 1996
% To Thanh Binh , IFAT University of Magdeburg Germany


epsilon=1e-7; 
beta=2;

if all(x<=10)&all(x >= 0), 

  g=zeros(2,1);
  gcons(1)=  x(1)^2 -x(2) +1;
  gcons(2)= 1-x(1)+(x(2)-4)^2;
  g(1)=sum((abs(gcons).*(gcons > epsilon)).^beta);
  g(2)=-(sin(2*pi*x(1))^3)*sin(2*pi*x(2)) /(sum(x)*(x(2)^3));

else,
  g=inf;  
end
%
