function cont()
% cont()
% Contour of the Banana Function in the parameter space
% for optimization without not-strict restrictions

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
plot(1,1,'ro');text(1,1,'Solution','color','w');
grid
