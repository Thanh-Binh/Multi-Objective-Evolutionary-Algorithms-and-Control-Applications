function rcont3()
% rcont3()
% Graphical diplay for the pareto-optimal set and the feasible region for 
% a bi-objective optimization with 
%    1. strict restrictions: f(1) must be in the interval [0 1100];
%                            f(2) must be in the interval [0 1000]
%    2. not-strict restrictions which are described by a system 
%       of inequalities: x(1) must be in the interval [-5 10]
%                        x(2) must be in the interval [-5 10] .
%
%
% See also: ROFUN3.M 


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


hold off
t=0:.1:5;
t1=-5:.1:10;
plot(2*t.^2,2*(t-5).^2,'g-');
hold on
plot(1000,850,'ro')
text(1000,850,'Start Point')
plot(25+t1.^2,100+(t1-5).^2,'b')
plot(100+t1.^2,25+(t1-5).^2,'b')
plot([200 ,200],[0, 50],'b')
plot([0 ,50],[200, 200],'b')

set(gca,'Xlim',[0 1100],'Ylim', [0 1000]);

