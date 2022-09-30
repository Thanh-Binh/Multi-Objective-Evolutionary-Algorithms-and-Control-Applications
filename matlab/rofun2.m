function g=rofun2(x);
% g=rofun2(x);
% Caculate the value of a Multi-Modal-Function for optimization 
% with 
%    1. strict restrictions: x must be in the interval [-5 10];
%    2. not-strict restrictions which are described by a system 
%       of inequalities: x(1) must be in the interval [0 6]
%                        x(2) must be in the interval [0 6] .
%
% Here the starting point of optimization is not in the given region of
% the two-dimensional space. That means restrictions are not satisfied by
% the starting population. However we can achieve the same results as in
% the case the starting population is in the given region.
%
%
% See also:  RCONT2.M

% All Rights Reserved, 04 July 1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany

if (-5<=x(1))&(x(1)<=10)&(-5<=x(2))&(x(2)<=10),
   gcons=[-x(1), x(1)-6, -x(2), x(2)-6];
   not_satisfy=find(gcons>0);
   if isempty(not_satisfy),
      gcons=0;
   else,
      gcons=sum(gcons(not_satisfy).^2);
   end 

   if (0<=x(1))&(x(1)<=2)&(0<=x(2))&(x(2)<=2),
       g=(x(1)-1)^2+(x(2)-1)^2+8;
   elseif (0<=x(1))&(x(1)<=2)&(2<=x(2))&(x(2)<=4),
       g=(x(1)-1)^2+(x(2)-3)^2+5;
   elseif (0<=x(1))&(x(1)<=2)&(4<=x(2))&(x(2)<=6),
       g=(x(1)-1)^2+(x(2)-5)^2+4;
   elseif (2<=x(1))&(x(1)<=4)&(0<=x(2))&(x(2)<=2),
       g=(x(1)-3)^2+(x(2)-1)^2+7;
   elseif (2<=x(1))&(x(1)<=4)&(2<=x(2))&(x(2)<=4),
       g=(x(1)-3)^2+(x(2)-3)^2+9;
   elseif (2<=x(1))&(x(1)<=4)&(4<=x(2))&(x(2)<=6),
       g=(x(1)-3)^2+(x(2)-5)^2+3;
   elseif (4<=x(1))&(x(1)<=6)&(0<=x(2))&(x(2)<=2),
       g=(x(1)-5)^2+(x(2)-1)^2+1;
   elseif (4<=x(1))&(x(1)<=6)&(2<=x(2))&(x(2)<=4),
       g=(x(1)-5)^2+(x(2)-3)^2+6;
   elseif (4<=x(1))&(x(1)<=6)&(4<=x(2))&(x(2)<=6),
       g=(x(1)-5)^2+(x(2)-5)^2+2;
   else
       g=100; 
   end
   g=[gcons;g];
else,
   g=inf;
end

