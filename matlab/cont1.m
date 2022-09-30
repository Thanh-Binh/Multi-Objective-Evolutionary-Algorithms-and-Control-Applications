function cont1()
% cont1()
% Contours of the Six Hump Camel Back Function
% in the parameter space by optimization without
% not-strict restriction
%
% See also: OFUN1.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



hold off
xx = [-2.5:0.06:2.5]';
yy = [-1.5:0.06:1.5]';
[x1,y1]=meshgrid(xx',yy');
meshd =4*(x1.*x1).^2-2.1*(x1.*x1).^4+((x1.*x1).^6)/3+x1.*y1-4*(y1.*y1).^2+...
       4*(y1.*y1).^4+1.0316 ;
conts=1:2:10;
conts = [conts,30,80,300];
contour(xx,yy,meshd,conts)
hold on
plot(-1.25,.8,'wo');plot(1.25,-.8,'wo');plot(-1.1,-.7,'wo');plot(1.1,.7,'wo');
plot(-1.05,-.1,'wo');plot(1.05,.1,'wo');
plot(.0898,-.7126,'g+',-.0898,.7126,'g+')
text(.0898,-.7126 ,'g1');text(-.0898,.7126 ,'g2');

