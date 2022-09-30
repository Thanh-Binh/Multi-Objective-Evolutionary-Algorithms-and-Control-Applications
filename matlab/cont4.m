function cont4()
% Contour of the Griewangk-Function in the parameter space
% by the optimization without not-strict restrictions
%
% See also: OFUN4.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany

k=100;

hold off

[x1,y1]=meshgrid([-50*k:1*k:50*k]);
z=(x1.^2+y1.^2)/4000 -cos(x1).*cos(y1/sqrt(2))+1;
contour(x1,y1,z,[1:10:100]);
axis(k*[-50 50 -50 50]);
hold on


