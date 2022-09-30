function g=rofun5(x)
% g=rofun5(x)
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
    if x <=1,
       g(2)=-x;
    elseif (x>1)&(x<=3),
       g(2)=-2+x;
    elseif (x>3)&(x<=4),
       g(2)=4-x;
    elseif (x>4),
       g(2)=-4+x;
    end     
    g(3)=(x-5)^2;   
else,
   g=inf;
end
%
