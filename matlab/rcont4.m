function rcont4();

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



hold off
k=1000;
t=0:.2:2;
plot(t,1+sqrt(1-(t-1).^2));
hold on
plot(t,1-sqrt(1-(t-1).^2));
axis(k*[0 1 0 1]);
