function fvec = ofun7(x)
% fvec = ofun7(x)
% Beale function 
% Dimensions -> n=2, m=3              
% Standard starting point -> x=(1,1) 
% Minima -> f=0 at (3,0.5)            

% To Thanh Binh, July 1996

fvec = [0;abs([1.5-x(1)*(1-x(2));2.25-x(1)*(1-x(2)^2)])]; 
