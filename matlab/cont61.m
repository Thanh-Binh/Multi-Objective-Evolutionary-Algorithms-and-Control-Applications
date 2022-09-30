function cont61()
% The Schwefel-Function


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



k=1;
hold off

[x1,y1]=meshgrid([-50*k:.1*k:50*k]);
z=-(x1*sin(sqrt(abs(x1))) + y1*sin(sqrt(abs(y1))));
contour(x1,y1,z)  %,[1:10:100]);
hold on
axis(k*[-50 50 -50 50]);


