function g=rofun43(x)
% search for the feasible space like hyperball 
%           (x1-1)^2 + (x2-1)^2 +...+ (xn-1)^2 =1 


% All Rights Reserved, 05-July-1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany

k=100;

if (all(x>=0)&all(x<=k)),
    epsilon=1e-4;
    g=(x(1)-1).^2 + (x(2)-1).^2 -1;
    if g>epsilon, g=g^2;else, g=0;end   
else,
   g=inf;
end
%
