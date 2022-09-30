function rcont10()
% Display the feasible region of a bi-objective optimization problem 
% subject to Non-linear Constrains 


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


hold off

space=1;   

if space==1, % in parameter space

   y=[-2:.01:5];
   plot(5-sqrt(25-y.^2),y);
   hold on
   y=0:.1:5;
   plot(y,y,'+b');
   y=[4.6:.01:5];
   plot(5+sqrt(25-y.^2),y); 
   y=[-2:.01:4.62];
   plot(8-sqrt(7.7^2-(y+3).^2),y);

elseif space==2,
   

end
