function g=m96g4(x)
% g=m96g4(x)
% Test Case #4 of Michalevicz 1996
%   'Evolutionary Algorithms for Constrainted Parameter Optimization Prob.'
%
% Objective function:
%        f(x) =5.3578547*x(3)^2 + .8356891*x(1)*x(5)+37.293239*x(1)-40792.141;
% subject to  non-linear constraints:
%  0<=85.334407 + .0056858*x(2)*x(5)+.00026*x(1)*x(4)-.0022053*x(3)*x(5)<=92
%  90<=80.51249 + .0071317*x(2)*x(5)+.0029955*x(1)*x(2)+.0021813*x(3)^2<=110
%  20<=9.300961 + .0047026*x(3)*x(5)+.0012547*x(1)*x(3)+.0019085*x(3)*x(4)<=25
%
% and bounds
%  [78 33 27 27 27] <= x <= [102 45 45 45 45];
%
% EVOLINOC found the best value: fmin=-31025 at
%      (78.0001 33.0072 27.0760 44.9872 44.9591)  (see m96g4.mat)


% All Rights Reserved, 05-July-1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany


epsilon=0; beta=2;

if all(x<=[102 45 45 45 45]) & all(x >= [78 33 27 27 27]), 

  g=zeros(2,1);gcons=zeros(1,6);
  tmp=85.334407 + .0056858*x(2)*x(5)+.00026*x(1)*x(4)-.0022053*x(3)*x(5);
  gcons([1,2])=[tmp 92-tmp];
  tmp=80.51249 + .0071317*x(2)*x(5)+.0029955*x(1)*x(2)+.0021813*x(3)^2;
  gcons([3,4])=[tmp-90 110-tmp];
  tmp=9.300961 + .0047026*x(3)*x(5)+.0012547*x(1)*x(3)+.0019085*x(3)*x(4);
  gcons([5,6])=[tmp-20 25-tmp];
  g(1)=sum((abs(gcons).*(gcons < -epsilon)).^beta);
  g(2)=5.3578547*x(3)^2 + .8356891*x(1)*x(5)+37.293239*x(1)-40792.141;

else,
  g=inf;  
end
