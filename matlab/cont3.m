function cont3()
% cont3()
% to plot the pareto-optimal set in the objective function space
% for the demo the multiobjective optimization
% by optimization without not-strict-restrictions
%
% See also: OFUN3.M


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



hold off

t=0:.1:5;
plot(2*t.^2,2*(t-5).^2,'g-');
axis([0 150 0 150]);
hold on
