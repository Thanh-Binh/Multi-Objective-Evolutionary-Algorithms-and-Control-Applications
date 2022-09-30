function micont3();
% Test Case #4 of Michalevicz 1994
%   'Evolutionary optimization of constrained problems'
%
%   Proceeding of the 3rd Annual Conference on Evolutionary Programming
%   A.V. Sebald and L.J. Fogel, World Scientific Publishing, River Edge,
%   NJ, 1994, pp. 98--108
%
% Objective function:
%        f(x) = .01*x(1)^2 +x(2)^2
% subject to  non-linear constraints:
%        x(1)*x(2) -25 >=0
%        x(1)^2 + x(2)^2 -25 >=0
% and bounds
%        2 <= x(1) <= 50; 0 <= x(2) <=50
%
% Global solution is (sqrt(250),sqrt(2.5))=(15.811388, 1.581139),
% fmin=5
% the starting feasible point (2,2)


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


x1=[2:.01:5];
x2=[0:.01:5];
cla 
hold off

plot(x1,25./x1) ;
hold on
plot(x1,sqrt(25-x1.^2)) ;

text(15.811,1.5811,'+','color','r')
axis([0 5 0 5])
