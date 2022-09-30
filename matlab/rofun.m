function gf=rofun(x);
% gf=rofun(x);
% Caculate the value of Banana function for optimization with
%    1. strict restrictions: x must be in the interval [-10 10];
%    2. not-strict restrictions which are described by a system 
%       of inequalities: x(1) must be in the interval [-3 3]
%                        x(2) must be in the interval [-1.5 4.5] .
%
% Here the starting point of optimization is not in the given region of
% the two-dimensional space. That means restrictions are not satisfied by
% the starting population. However we can achieve the same results as in
% the case the starting population is in the given region.
%
% See also: RCONT.M

% All Rights Reserved, 04 July 1996
% To Thanh Binh , IFAT University of Magdeburg Germany

if (abs(x(1)) <= 10)&(abs(x(2))<=10), 
  gcons=[-3-x(1), x(1)-3, -1.5-x(2), x(2)-4.5];
  not_satisfy=find(gcons>0);
  if isempty(not_satisfy),
     gcons=0;
  else,
     gcons=sum(gcons(not_satisfy).^2);
  end 
  gf=[gcons;(100*(x(2)-x(1)^2)^2 +(x(1)-1)^2)];

else,
  gf=inf;  
end
%
