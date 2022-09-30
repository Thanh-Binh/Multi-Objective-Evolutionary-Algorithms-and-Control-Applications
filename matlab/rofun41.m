function g=rofun41(x)
% For the Method of Inequality  with 
%    1. strict restrictions: x must be in the interval [0 k*100];
%    2. not-strict restrictions which are described by a system 
%       of equalities: 
%           (x1-1)^2 + (x2-1)^2 =1 and
%           (x1-3)^2 + (x2-1)^2 =1 and
%
%  Solution is only one at [2,1];
%
% See also:  RCONT41.M

% All Rights Reserved, 05-July-1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany

k=100;

if (all(x>=0)&all(x<=k)),
    epsilon=1e-4;
    g(1)=(x(1)-1).^2 + (x(2)-1).^2 -1;
    g(2)=(x(1)-3).^2 + (x(2)-1).^2 -1;
    g=sum((abs(g).*(g>epsilon)).^2);
   
else,
   g=inf;
end
%
