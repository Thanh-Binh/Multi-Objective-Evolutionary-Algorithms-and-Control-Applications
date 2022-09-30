function g=ofun2(x)
% g=ofun2(x)
% Objective function for the Multi Modal function
% by optimization without not-strict-restrictions
%
% See also: CONT2.M


% All Rights Reserved, July 1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany


k=3;
range=k*[0,6];pos1=k*[1,3,5];pos2=k*[2,4];

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
    g=(x(1)-pos1(3))^2+(x(2)-pos1(1))^2+1;
  elseif (pos2(2)<=x(1))&(x(1)<=range(2))&(pos2(1)<=x(2))&(x(2)<=pos2(2)),
    g=(x(1)-pos1(3))^2+(x(2)-pos1(2))^2+6;
  elseif (pos2(2)<=x(1))&(x(1)<=range(2))&(pos2(2)<=x(2))&(x(2)<=range(2)),
    g=(x(1)-pos1(3))^2+(x(2)-pos1(3))^2+2;
  end
  g=[0;g];
else,
  g=inf;
end
%
