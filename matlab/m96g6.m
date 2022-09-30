function g=m96g6(x)
% g=m96g6(x)
% EA for the solving of the Non-linear Constrained Optimization 
% This example comes from:
%    'On the Use of Non-Stationary Penalty Functions to Solve
%     Non-linear Constrained Optimization Problems with GA's'
%
%    Authors: J. Joines and C. Houck
%    North Carolina State University
%
% Test Case #6 of Michalevicz 1996
%   'Evolutionary Algorithms for Constrainted Parameter Optimization Prob.'
%
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



% All Rights Reserved, 05-July-1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany


if (x(1)<=100)&(x(1)>=13)&(x(2)<=100)&(x(2)>=0),
    epsilon=1e-6; beta=2;
    g=zeros(2,1);

    gcons(1)=(x(1)-5)^2+(x(2)-5)^2 - 100;
    gcons(2)=-(x(1)-6)^2-(x(2)-5)^2 +82.81;

    g(1)=sum((abs(gcons).*(gcons < -epsilon)).^beta);
    g(2)=(x(1)-10)^3 +(x(2)-20)^3;
    %g=[0;g];    % multiobjective description
else,
    g=inf;
end
%
