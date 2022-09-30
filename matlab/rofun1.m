function gf=rofun1(x)
% gf=rofun1(x)
% Caculate the value of the Six Hump Camel Back Function for optimization 
% with 
%    1. strict restrictions: x must be in the interval [-4.5 4.5];
%    2. not-strict restrictions which are described by a system 
%       of inequalities: x(1) must be in the interval [-2.5 1.5]
%                        x(2) must be in the interval [-2.5 1.5] .
%
%
% See also: RCONT1.M

% All Rights Reserved, 04 July 1996
% To Thanh Binh , IFAT University of Magdeburg Germany


if (abs(x(1))<=4.5)&(abs(x(2))<=4.5),
  gcons=[-2.5-x(1), x(1)-1.5, -2.5-x(2), x(2)-1.5];
  not_satisfy=find(gcons>0);
  if isempty(not_satisfy),
     gcons=0;
  else,
     gcons=sum(gcons(not_satisfy).^2);
  end 
  gf=[gcons;4*x(1)^2-2.1*x(1)^4+x(1)^6/3+x(1)*x(2)-4*x(2)^2+4*x(2)^4+1.1];

else,
  gf=inf;
end
%
