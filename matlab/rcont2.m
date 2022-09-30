function rcont2()
% rcont2()
% Contour for a Multi-Modal-Function for optimization with
%    1. strict restrictions: x must be in the interval [-5 10];
%    2. not-strict restrictions which are described by a system 
%       of inequalities: x(1) must be in the interval [0 6]
%                        x(2) must be in the interval [0 6] .
%
% Here the starting point of optimization is not in the given region of
% the two-dimensional space. That means restrictions are not satisfied by
% the starting population. However we can achieve the same results as in
% the case the starting population is in the given region.
%
%
% See also:  ROFUN2.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany




hold off

x1=meshgrid(0:.4:2);
x2=meshgrid(2:.4:4);
x3=meshgrid(4:.4:6);
y1=x1';y2=x2';y3=x3';
z1=(x1-1).^2+(y1-1).^2+8;
z2=(x1-1).^2+(y2-3).^2+5;
z3=(x1-1).^2+(y3-5).^2+4;
z4=(x2-3).^2+(y1-1).^2+7;
z5=(x2-3).^2+(y2-3).^2+9;
z6=(x2-3).^2+(y3-5).^2+3;
z7=(x3-5).^2+(y1-1).^2+1;
z8=(x3-5).^2+(y2-3).^2+6;
z9=(x3-5).^2+(y3-5).^2+2;

contour(x1,y1,z1);
hold on
contour(x1,y2,z2);
contour(x1,y3,z3);
contour(x2,y1,z4);
contour(x2,y2,z5);
contour(x2,y3,z6);
contour(x3,y1,z7);
contour(x3,y2,z8);
contour(x3,y3,z9);
plot([1 1 1;3 3 3;5 5 5],[1 3 5;1 3 5;1 3 5],'b.','markersize',10);
text(1.1,1,'8','color','b')
text(1.1,3,'5','color','b')
text(1.1,5,'4','color','b')
text(3.1,1,'7','color','b')
text(3.1,3,'9','color','b')
text(3.1,5,'3','color','b')
text(5.1,1,'1','color','b')
text(5.1,3,'6','color','b')
text(5.1,5,'2','color','b')

set(gca,'Xlim',[-5 10],'Ylim', [-5 10])
