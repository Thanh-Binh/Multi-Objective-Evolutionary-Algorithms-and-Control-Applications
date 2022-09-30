function g=m96g11(x)
% g=m96g11(x)
% Test case 11 of Michalevicz
%
%     f(x)=x(1)^2+(x(2)-1)^2;
%
% subject to the constraints:
%     
%  x(2)-x(1)^2=0
%
% and bounds:  -1<=x<=1;
%     fmin=.75000455 at x=(.70711,.5) and x=(-.70711,.5)


% All Rights Reserved, 05-July-1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany



epsilon=1e-7; beta=2;

if all(abs(x)<=1),
   g=zeros(2,1);
   gcons=abs(x(2)-x(1)^2) ;
   if gcons > epsilon, g(1)=gcons^beta; end
   g(2)=x(1)^2+(x(2)-1)^2;
else
   g=inf;
end
  
