function cont3n()
% cont3n()
% To plot the contours of two objective functions in the parameter space
% by optimization without not-strict restrictions

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



hold off
xx = [-5:0.2:10]';
yy = [-5:0.2:10]';
[x1,y1]=meshgrid(xx',yy');
meshd1 = x1.^2+y1.^2 ;meshd2 = (x1-5).^2+(y1-5).^2;
axis([-5,10,-5,10]);
contour(xx,yy,meshd1,1:2:10)
hold on
contour(xx,yy,meshd2,conts)
plot(0,0,'wo',5,5,'wo')

