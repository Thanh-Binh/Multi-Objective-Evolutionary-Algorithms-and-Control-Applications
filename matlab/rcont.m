function rcont()
% rcont()
% Contour for the Banana Function for optimization with 
%    1. strict restrictions: x must be in the interval [-10 10];
%    2. not-strict restrictions which are described by a system 
%       of inequalities: x(1) must be in the interval [-3 3]
%                        x(2) must be in the interval [-1.5 4.5] .
% 
% Here the starting point of optimization is not in the given region of
% the two-dimensional space. That means restrictions are not satisfied by
% the starting population. However we can achieve the same results as in
% the case the starting population is in the given region.
%
%
% See also:  ROFUN.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany

hold off

xx = [-3:0.125:3]';
yy = [-1.5:0.125:4.5]';
[x1,y1]=meshgrid(xx',yy');
meshd = 100.*(y1-x1.*x1).^2 + (1-x1).^2;

conts = exp(3:20);
contour(xx,yy,meshd,conts)

hold on
plot(1,1,'ro');text(1,1,'Solution');
grid
set(gca,'Xlim',[-10 10],'Ylim', [-10 10])

