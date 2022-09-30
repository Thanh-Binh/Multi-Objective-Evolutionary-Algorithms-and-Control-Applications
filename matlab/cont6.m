function cont6()
% cont6()
% contour for the multi-objective optimization problem: 
% bbeale.m or ofun6.m

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany

 

hold off

testcase=2;

if testcase==1,      % in the objective function space
                     % optimization without nonlinear constraints
   plot3(0,0,0,'og'); 
   text(0,0,0,'Solution');
   axis([0 10 0 10 0 10]);
   hold on

elseif testcase ==2, % in the parameter space
                     % optimization with nonlinear constraints

   y=[-1.85:.1:2.9];
   
   plot(sqrt(9-(y-0.5).^2),y); 
   hold on
   plot(1 + sqrt(6.25-(y-0.5).^2),y);
   plot(3,.5,'og');
   text(3,.5,'Solution');
   %axis([1.6 4 -2 3])
end
