function f = ofun6(x,m)
% f= ofun6(x,m)
% Beale function 
% Dimensions -> n=2, m=3              
% Standard starting point -> x=(1,1) 
% Minima -> f=0 at (3,0.5)            

% To Thanh Binh, March 1996

if nargin <2, m=2;end
testcase=2;

if testcase==1, % optimization without nonlinear constraints
   if (all(x <= 10) & all(x >= 0)),
      if m==2,
         f = [0;abs([1.5-x(1)*(1-x(2));2.25-x(1)*(1-x(2)^2)])];
      else, 
         f = [0;abs([1.5-x(1)*(1-x(2));2.25-x(1)*(1-x(2)^2);2.625-x(1)*(1-x(2)^3)])]; 
      end
   else,
      f=inf;
   end
elseif testcase==2,  % optimization with nonlinear constraints
   if all(abs(x) <= 10),
      if m==2,
         f = [0;abs([1.5-x(1)*(1-x(2));2.25-x(1)*(1-x(2)^2)])];
      else, 
         f = [0;abs([1.5-x(1)*(1-x(2));2.25-x(1)*(1-x(2)^2);2.625-x(1)*(1-x(2)^3)])]; 
      end
      gcons(1)= -x(1)^2 - (x(2)-0.5)^2 +9; 
      gcons(2)= (x(1)-1)^2 + (x(2)-0.5)^2 -6.25;
      f(1)=sum((abs(gcons).*(gcons > 0)).^2);
   else,
      f=inf;
   end
      
end
