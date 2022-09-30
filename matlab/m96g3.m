function g=m96g3(x);
% g=m96g3(x);
% Test Case #3 of Michalevicz 1996
%   'Evolutionary Algorithms for Constrainted Parameter Optimization Prob.'
%
%   Proceeding of the 3rd Annual Conference on Evolutionary Programming
%   A.V. Sebald and L.J. Fogel, World Scientific Publishing, River Edge,
%   NJ, 1994, pp. 98--108
%
% Objective function:
%        f(x) = n^(n/2) *prod(x)
% subject to  non-linear constraints:
%        sum(x.^2)=1
% and bounds
%        0 <= x <= 1;
%
% Global solution is 1/sqrt(n)*ones(1,n),
% fmin=1


% All Rights Reserved, 01 August 1996
% To Thanh Binh , IFAT University of Magdeburg Germany


epsilon=1e-7; 

if all(x<=1)&all(x >= 0), 

  g=zeros(2,1);n=length(x);
  gcons= abs(sum(x.^2)-1);
  if gcons > epsilon, g(1)=gcons^2;end
  g(2)=(n^(n/2)) *prod(x);

else,
  g=inf;  
end
%
