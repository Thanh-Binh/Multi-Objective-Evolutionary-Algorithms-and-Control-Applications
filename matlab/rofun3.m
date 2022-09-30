function f=rofun3(x);
% f=rofun3(x)
% Caculate the objective function values of a bi-objective optimization 
% with 
%    1. strict restrictions: f(1) must be in the interval [0 1100];
%                            f(2) must be in the interval [0 1000]
%    2. not-strict restrictions which are described by a system 
%       of inequalities: x(1) must be in the interval [-5 10]
%                        x(2) must be in the interval [-5 10] .
%
%
% See also: RCONT3.M or RCONT3N.M

% All Rights Reserved, 05 March 1996
% To Thanh Binh , IFAT University of Magdeburg Germany


f=[x(1)^2+x(2)^2;(x(1)-5)^2+(x(2)-5)^2];

% check if the strict restrictions are satisfied
% f <= [1100;1000]
if (f(1)>1100)|(f(2)>1000),
     f=inf; 
else,
   fcons=0;
   if  x(1) <-5
       fcons=fcons+(x(1)+5)^2;
   end
   if x(1) > 10
       fcons=fcons+(10-x(1))^2;
   end
   if  x(2) <-5
       fcons=fcons+(x(2)+5)^2;
   end
   if x(2) > 10
       fcons=fcons+(10-x(2))^2;
   end
   f=[fcons;f];
   
end



