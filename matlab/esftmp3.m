function f=esftmp3(x) 
% Temporary objective function for the evolution strategy 

% Written on 22-Jul-2018 at 21:19 by Evolution Strategy 

xx=x(:);
if all(xx <= [10;10])&  all(xx >= [-5;-5]),
    f=ofun3(x);
else,
    f=inf;
end 
