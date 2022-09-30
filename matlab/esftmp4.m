function f=esftmp4(x) 
% Temporary objective function for the evolution strategy 

% Written on 23-Jul-2018 at 15:23 by Evolution Strategy 

xx=x(:);
if all(xx <= [10;10])&  all(xx >= [-5;-5]),
    f=ofun3(x);
else,
    f=inf;
end 
