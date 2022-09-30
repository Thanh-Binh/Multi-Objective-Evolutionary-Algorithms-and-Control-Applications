function g=m96g2(x);
% g=m96g2(x);
% Test Case #2 of Michalevicz 1996
%   'Evolutionary Algorithms for Constrainted Parameter Optimization Prob.'
%
%   Proceeding of the 3rd Annual Conference on Evolutionary Programming
%   A.V. Sebald and L.J. Fogel, World Scientific Publishing, River Edge,
%   NJ, 1994, pp. 98--108
%
% Objective function:
%        f(x) = -abs((sum(cos(x).^4) -2*prod(cos(x).^2))/sqrt(sum([1:length(x)].*(x.^2))));
% subject to  non-linear constraints:
%        prod(x) -.75 >=0
%        -sum(x) + 7.5*length(x) >=0
% and bounds
%        0 <= x <= 10;
%


% All Rights Reserved, 01 August 1996
% To Thanh Binh , IFAT University of Magdeburg Germany


epsilon=1e-12; beta=2;

if all(x<=10) & all(x >= 0), 

  g=zeros(2,1);n=length(x);
  gcons(1)= prod(x) -.75;
  %gcons(2)=-sum(x) + 7.5*n;
  g(1)=sum((abs(gcons).*(gcons < -epsilon)).^beta);
  g(2)=-abs((sum(cos(x).^4) -2*prod(cos(x).^2))/sqrt(sum([1:n].*(x.^2))));

else,
  g=inf;  
end
%
