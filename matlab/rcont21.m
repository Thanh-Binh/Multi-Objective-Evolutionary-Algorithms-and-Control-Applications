function rcont21()
% rcont21()
% [resf,g]=rofun21(x,resfbound)
% Contour for the Multi-Modal-Function (like rcont2.m) for  
% optimization with 
%    1. strict restrictions: x must be in the interval [0 18];
%    2. not-strict restrictions which are described by a system 
%       of inequalities: x(1) must be in the interval [12 18]
%                        x(2) must be in the interval [12 18] .
%
%
% See also:  ROFUN21.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany




k=3;
hold off

x1=meshgrid(k*[0:.1:2]);
x2=meshgrid(k*[2:.1:4]);
x3=meshgrid(k*[4:.1:6]);
y1=x1';y2=x2';y3=x3';
pos1=k*[1,3,5];
z1=(x1-pos1(1)).^2+(y1-pos1(1)).^2+8;
z2=(x1-pos1(1)).^2+(y2-pos1(2)).^2+5;
z3=(x1-pos1(1)).^2+(y3-pos1(3)).^2+4;
z4=(x2-pos1(2)).^2+(y1-pos1(1)).^2+7;
z5=(x2-pos1(2)).^2+(y2-pos1(2)).^2+9;
z6=(x2-pos1(2)).^2+(y3-pos1(3)).^2+3;
z7=(x3-pos1(3)).^2+(y1-pos1(1)).^2+1;
z8=(x3-pos1(3)).^2+(y2-pos1(2)).^2+6;
z9=(x3-pos1(3)).^2+(y3-pos1(3)).^2+2;
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
plot([pos1',pos1',pos1'],[pos1;pos1;pos1],'r.','markersize',10);

text(pos1(1)+.1,pos1(1),'+8','color','b')
text(pos1(1)+.1,pos1(2),'+5','color','b')
text(pos1(1)+.1,pos1(3),'+4','color','b')
text(pos1(2)+.1,pos1(1),'+7','color','b')
text(pos1(2)+.1,pos1(2),'+9','color','b')
text(pos1(2)+.1,pos1(3),'+3','color','b')
text(pos1(3)+.1,pos1(1),'+1','color','b')
text(pos1(3)+.1,pos1(2),'+6','color','b')
text(pos1(3)+.1,pos1(3),'+2','color','b')

%plot(k*[4 4],k*[4 6],'w')
%plot(k*[4 6],k*[4 4],'w')
% the global minima has the value 2

% the global minima has the value 4
% and is so far from the starting point
plot(k*[2 2],k*[4 6],'w')
plot(k*[0 2],k*[4 4],'w')

set(gca,'Xlim',k*[0 6],'Ylim', k*[0 6])
