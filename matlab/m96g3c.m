function m96g3c();
% m96g3c();
% Demo for n=2, Test Case #3 of Michalevicz 1996
%   'Evolutionary Algorithms for Constrainted Parameter Optimization Prob.'
%
%   Proceeding of the 3rd Annual Conference on Evolutionary Programming
%   A.V. Sebald and L.J. Fogel, World Scientific Publishing, River Edge,
%   NJ, 1994, pp. 98--108
%
% Objective function:
%        f(x) = n^(n/2) *prod(x)
% subject to  non-linear constraints:
%        sum(x.^2)=1
% and bounds
%        0 <= x <= 1;
%
% Global solution is 1/sqrt(n)*ones(1,n),
% fmin=1


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany




hold off

x=[0:.01:1];
plot(x,sqrt(1-x.^2));
hold on

%
