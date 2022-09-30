function g=rofun42(x,n,k)
% g=rofun42(x,n,k)
% For the Method of Inequality  with 
%    1. strict restrictions: x must be in the interval [0 k];
%    2. not-strict restrictions which are described by a system 
%       of inequalities: 
%           (x1-1)^2 + (x2-1)^2 +...+ (xn-1)^2 >=1
%           (x1-1.5)^2 + (x2-1.5)^2 +...+ (xn-1.5)^2 <=1
%
% Here the starting point of optimization is not in the given region of
% the two-dimensional space. That means restrictions are not satisfied by
% the starting population. The starting population is in a neighbourhood
% of the global minimum lying in the outside of the feasible region. It
% runs very quickly into the feasible region and then into the desired   
% minimum. 
%
%
% See also:  RCONT4.M

% All Rights Reserved, 05-July-1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany

if nargin < 3, k=100;end
if nargin < 2, n=2;end

epsilon=1e-7; beta=2;

if (all(x>=0)& all(x<=k)),

    g(1)=1-sum((x-ones(size(x))).^2);
    g(2)=sum((x-1.5*ones(size(x))).^2)-1;
    g=(sum((abs(g).*(g > epsilon)).^beta))^(beta);
    %g=sum((abs(g).*(g > epsilon)).^beta);

else,
   g=inf;
end
%
