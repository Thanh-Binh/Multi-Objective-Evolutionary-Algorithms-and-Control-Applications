function g=michal1(x);
% g=michal1(x);
% Test Case #1 of Michalevicz 1994
%   'Evolutionary optimization of constrained problems'
%
%   Proceeding of the 3rd Annual Conference on Evolutionary Programming
%   A.V. Sebald and L.J. Fogel, World Scientific Publishing, River Edge,
%   NJ, 1994, pp. 98--108
%
% Caculate the value of Banana function for optimization with
%   non-linear constraints:
%        x(1)   +x(2)^2 >=0
%        x(1)^2 +x(2)   >=0
% and bounds
%        abs(x(1)) <=.5; x(2) <=1
%
% Global solution is (.5,.25), fmin=.25
% the starting feasible point (0 0) 
%
% See also: RCONT.M

% All Rights Reserved, 04 July 1996
% To Thanh Binh , IFAT University of Magdeburg Germany


epsilon=1e-7; beta=2;

if (x(1) <=.5)&(x(1) >= -.5)&(x(2)<=1), 

  g=zeros(2,1);
  gcons=[(x(1)+x(2)^2); (x(1)^2 + x(2))];
  index=find(gcons < -epsilon);
  if ~isempty(index)
      g(1)=sum(abs(gcons(index)).^beta);
  end

  g(2)=100*(x(2)-x(1)^2)^2 +(x(1)-1)^2;

else,
  g=inf;  
end
%
