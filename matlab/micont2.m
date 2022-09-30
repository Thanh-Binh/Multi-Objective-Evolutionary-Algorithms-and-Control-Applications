function micont2();
% Test Case #1 of Michalevicz 1994
%   'Evolutionary optimization of constrained problems'
%
%   Proceeding of the 3rd Annual Conference on Evolutionary Programming
%   A.V. Sebald and L.J. Fogel, World Scientific Publishing, River Edge,
%   NJ, 1994, pp. 98--108
%
% Objective function:
%        f(x) = -x(1)-x(2)
% subject to  non-linear constraints:
%        2*x(1)^4 -8*x(1)^3 +8*x(1)^2 +2 -x(2) >=0
%        4*x(1)^4 -32*x(1)^3 +88*x(1)^2 -96*x(1)+36 -x(2) >=0
% and bounds
%        0 <= x(1) <= 3; 0 <= x(2) <=4
%
% Global solution is (2.3295,3.1783), fmin=-5.5079
% the starting feasible point (0 0) 
% Property of the feasible region: almost disconnected


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



x1=[.61:.01:1.6];
x2=[0:.01:.62];
x3=[1.6:.01:2.33];
x4=[2.33:.01:3];

cla 
hold off

plot(x2,2*x2.^4 -8*x2.^3 +8*x2.^2 +2 ) ;
hold on
plot(x3,2*x3.^4 -8*x3.^3 +8*x3.^2 +2 ) ;
plot(x1,4*x1.^4 -32*x1.^3 +88*x1.^2 -96*x1+36);

plot(x4,4*x4.^4 -32*x4.^3 +88*x4.^2 -96*x4+36);

text(2.3295,3.1783,'+','color','r')
axis([0 3 0 4])
