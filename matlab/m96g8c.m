function m96g8c()
% Display the feasible region of the Non-linear Constrained Optimization 
% This example comes from:
% Test Case #8 of Michalevicz 1996
%   'Evolutionary Algorithms for Constrainted Parameter Optimization Prob.'
%
%   Proceeding of the 3rd Annual Conference on Evolutionary Programming
%   A.V. Sebald and L.J. Fogel, World Scientific Publishing, River Edge,
%   NJ, 1994, pp. 98--108
%
% Objective function:
%        f(x) = -sin(2*pi*x(1))^3 *sin(2*pi*x(2)) /(sum(x)* (x(1)^3))
% subject to  non-linear constraints:
%        x(1)^2 -x(2) +1 <=0
%        1-x(1)+(x(2)-4)^2 <=0
% and bounds
%        0 <= x <= 10;
%


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



x=[1.5:.1:2];x1=[2:.1:10];
x2=[1.5:.1:10];
hold off

plot(x,x.^2+1);
hold on
plot(x1,4+sqrt(x1-1));
plot(x2,4-sqrt(x2-1));

%
