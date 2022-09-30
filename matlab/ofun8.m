
function f = ofun8(x);
% OBJective function for ackley`s path 
%
% This function implements the RASTRIGIN function 6.
% Source: Ackley, D. "A connectionist machine for genetic hillclimbing";
%         International series in engineering and computer science, SECS 28,
%         Boston: Kluwer Academic Publishers, 1989
%      look in ICGA5 page 592
% Description of the function:
%        f= -a*exp(-b*sqrt(1/Nvar*sum(xi^2))-exp(1/Nvar*sum(cos(c*xi)))+a+e
%        the feasible region: -32.768 <= xi <= 32.768
% global minimum at (xi)=(0) ; fmin=0



Nvar = length(x);
a = 20; b = 0.2; c = 2 * pi; e = exp(1);

if all(abs(x)<=32.768*ones(size(x))),

   f = -a * exp(-b * sqrt(1/Nvar * sum((x .* x)')'));
   f = [0; (f - exp(1/Nvar * sum(cos(c * x)')') + a + e)];
else,
   f=inf;
end



