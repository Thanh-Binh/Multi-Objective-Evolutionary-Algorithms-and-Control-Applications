function g=rofun6(x)
% g=rofun6(x)
% For Multi-Objective Optimization  with 
%    1. strict restrictions: x must be in the interval [-20 20];
%    2. not-strict restrictions which are described by a system 
%       of inequalities
%
% This example comes from Osyczka, Japan in MENDEL'96 (Brno)

% All Rights Reserved, 05-July-1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany



if all(abs(x)<=20),
    g=zeros(3,1);
    g(2)=(x(1)-2)^2 + (x(2)-1)^2+2;   
    g(3)=9*x(1)-(x(2)-1)^2;
    gconstmp=225-x(1)^2-x(2)^2;
    if  gconstmp <0,
       g(1)=g(1)+gconstmp^2;
    end
    gconstmp=-x(1)+3*x(2)-10;
    if  gconstmp <0,
       g(1)=g(1)+gconstmp^2;
    end 
   
else,
   g=inf;
end
%
