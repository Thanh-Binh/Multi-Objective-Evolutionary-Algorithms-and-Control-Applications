function g=m96g6func(x,y)

% All Rights Reserved, 05-July-1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany


    epsilon=1e-6; beta=2;

    gcons1=(x-5).^2+(y-5).^2 - 100;
    [n,m]=size(gcons1);
    gcons2=-(x-6).^2-(y-5).^2 +82.81;
    g=(abs(gcons1).*(gcons1 < -epsilon)).^beta + ...
      (abs(gcons2).*(gcons2 < -epsilon)).^beta;
%
