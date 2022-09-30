function m96g6c()
% Display the feasible region of the Non-linear Constrained Optimization 
% This example comes from:
%    'On the Use of Non-Stationary Penalty Functions to Solve
%     Non-linear Constrained Optimization Problems with GA's'
%
%    Authors: J. Joines and C. Houck
%    North Carolina State University
%
% Optimization Problem 1:
%
%     f(x)=(x1-10)^3 +(x2-20)^3;
%
% subject to the constraints:
%     
%    (x1-5)^2+(x2-5)^2 >= 100 
%    (x1-6)^2+(x2-5)^2 <= 82.81
%
% and bounds: 13 <=x1<=100; 0<=x2<=100 
%
% well-known global solution is (14.095 .84296);
%       fmin=-6961.81381


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



y=[.843:.001:9.157];

hold off

plot(5+sqrt(100-(y-5).^2),y);
hold on
plot(6+sqrt(82.81-(y-5).^2),y);
%axis([14 15.2 0 10]);
%
