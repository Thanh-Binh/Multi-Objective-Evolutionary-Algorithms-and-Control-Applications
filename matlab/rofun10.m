function f=rofun10(x);
% f=rofun10(x)
% Caculate the objective function values of a bi-objective optimization 
% with the non-convex feasible region

% All Rights Reserved, 25 Nov. 1996
% To Thanh Binh , IFAT University of Magdeburg Germany



if all(x >= -15) & all(x <= 30),
   f=[0;4*(x(1)^2+x(2)^2);(x(1)-5)^2+(x(2)-5)^2];
   gcons(1)=(x(1)-5)^2 + x(2)^2 - 25; 
   gcons(2)=-(x(1)-8)^2 - (x(2)+3)^2 + 7.7; 
   f(1)=sum(gcons.*(gcons > 0)).^2;
   
else,
   f=inf;
end



