function g=rofun21(x)
% g=rofun21(x)
% Caculate the value of the Multi-Modal-Function (like rofun2.m) for  
% optimization with 
%    1. strict restrictions: x must be in the interval [0 18];
%    2. not-strict restrictions which are described by a system 
%       of inequalities: x(1) must be in the interval [0 6]
%                        x(2) must be in the interval [12 18] .
%
% Here the starting point of optimization is not in the given region of
% the two-dimensional space. That means restrictions are not satisfied by
% the starting population. The starting population is in a neighbourhood
% of the global minimum lying in the outside of the feasible region. It
% runs very quickly into the feasible region and then into the desired   
% minimum. 
%
%
% See also:  RCONT21.M

% All Rights Reserved, 05 march 1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany


k=3;
range=k*[0,6];pos1=k*[1,3,5];pos2=k*[2,4];

% first check if the unchangable restrictions are achieved
if (x(1)>=range(1))&(x(1)<=range(2))&(x(2)>=range(1))&(x(2)<=range(2)),

     if (range(1)<=x(1))&(x(1)<=pos2(1))&(range(1)<=x(2))&(x(2)<=pos2(1)),
        g=(x(1)-pos1(1))^2+(x(2)-pos1(1))^2+8;
     elseif (range(1)<=x(1))&(x(1)<=pos2(1))&(pos2(1)<=x(2))&(x(2)<=pos2(2)),
        g=(x(1)-pos1(1))^2+(x(2)-pos1(2))^2+5;
     elseif (range(1)<=x(1))&(x(1)<=pos2(1))&(pos2(2)<=x(2))&(x(2)<=range(2)),
        g=(x(1)-pos1(1))^2+(x(2)-pos1(3))^2+4;
     elseif (pos2(1)<=x(1))&(x(1)<=pos2(2))&(range(1)<=x(2))&(x(2)<=pos2(1)),
        g=(x(1)-pos1(2))^2+(x(2)-pos1(1))^2+7;
     elseif (pos2(1)<=x(1))&(x(1)<=pos2(2))&(pos2(1)<=x(2))&(x(2)<=pos2(2)),
        g=(x(1)-pos1(2))^2+(x(2)-pos1(2))^2+9;
     elseif (pos2(1)<=x(1))&(x(1)<=pos2(2))&(pos2(2)<=x(2))&(x(2)<=range(2)),
        g=(x(1)-pos1(2))^2+(x(2)-pos1(3))^2+3;
     elseif (pos2(2)<=x(1))&(x(1)<=range(2))&(range(1)<=x(2))&(x(2)<=pos2(1)),
        g=(x(1)-pos1(3))^2+(x(2)-pos1(1))^2 +1;
     elseif (pos2(2)<=x(1))&(x(1)<=range(2))&(pos2(1)<=x(2))&(x(2)<=pos2(2)),
        g=(x(1)-pos1(3))^2+(x(2)-pos1(2))^2+6;
     elseif (pos2(2)<=x(1))&(x(1)<=range(2))&(pos2(2)<=x(2))&(x(2)<=range(2)),
        g=(x(1)-pos1(3))^2+(x(2)-pos1(3))^2+2;
     end
    gcons=0;
    if  x(1) > 6
       gcons=gcons+(x(1)-6)^2;
    end
    if x(2) < 12
       gcons=gcons+(x(2)-12)^2;
    end
    g=[gcons;g];
   
else,
   g=inf;
end
%
