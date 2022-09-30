function m96g6cont()


x=[5:.005:20];
y=[-15:.005:30];
hold off

[x1,y1]=meshgrid(x',y');
meshd = m96g6func(x1,y1);
conts = exp(3:20);
contour(x,y,meshd,20);
hold on
y=[.843:.001:9.157];

plot(5+sqrt(100-(y-5).^2),y);

plot(6+sqrt(82.81-(y-5).^2),y);
