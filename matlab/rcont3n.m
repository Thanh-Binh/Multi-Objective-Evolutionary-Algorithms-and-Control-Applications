function rcont3n()
% rcont3n()
% Display the contour and the feasible region for 
% a bi-objective optimization with 
%    1. search space:   f(1) must be in the interval [0 1100];
%                       f(2) must be in the interval [0 1000]
%    2. feasible region: x(1) must be in the interval [-5 10]
%                        x(2) must be in the interval [-5 10] .
%
%
% See also: ROFUN3.M 

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany

hold off

xx = [-5:0.2:10]';
yy = [-5:0.2:10]';
[x1,y1]=meshgrid(xx',yy');
meshd1 = x1.^2+y1.^2 ;meshd2 = (x1-5).^2+(y1-5).^2;
contour(xx,yy,meshd1,1:2:10)
hold on
contour(xx,yy,meshd2,conts)
%plot(-6,14,'o')
%text(-6,14,'Start Point')
plot(0,0,'wo',5,5,'wo')
plot([-5 -5],[10 -5]),
plot([-5 10],[10 10]),
plot([10 10],[10 -5]),
plot([-5 10],[-5 -5]),
set(gca,'Xlim',[-10 20],'Ylim', [-10 20])

