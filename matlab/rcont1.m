function rcont1()
% rcont1()
% Contour for the Six Hump Camel Back Function for optimization with
%    1. strict restrictions: x must be in the interval [-4.5 4.5];
%    2. not-strict restrictions which are described by a system 
%       of inequalities: x(1) must be in the interval [-2.5 -1.5]
%                        x(2) must be in the interval [-2.5 -1.5] .
%
% Here the starting point of optimization is not in the given region of
% the two-dimensional space. That means restrictions are not satisfied by
% the starting population. However we can achieve the same results as in
% the case the starting population is in the given region.
%
%
% See also:  ROFUN1.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



hold off

xx = [-2.5:0.06:2.5]';
yy = [-1.5:0.06:1.5]';
[x1,y1]=meshgrid(xx',yy');
meshd =4*(x1.*x1).^2-2.1*(x1.*x1).^4+((x1.*x1).^6)/3+x1.*y1-4*(y1.*y1).^2+...
       4*(y1.*y1).^4+1.1 ;
contour(xx,yy,meshd,[1:2:10,30, 80, 300])
hold on
plot(-1.25,.8,'o');plot(1.25,-.8,'o');plot(-1.1,-.7,'o');plot(1.1,.7,'o');
plot(-1.05,-.1,'o');plot(1.05,.1,'o');
plot(.0898,-.7126,'g+',-.0898,.7126,'g+')
text(.0898,-.7126 ,'g1');text(-.0898,.7126 ,'g2');
set(gca,'Xlim',[-4.5 4.5],'Ylim', [-4.5 4.5],'clipping','on')
