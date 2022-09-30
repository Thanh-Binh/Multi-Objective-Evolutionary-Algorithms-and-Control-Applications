function  [xa,sigma,gf]=esredist(xa,sigma,gf);
% [xa,sigma,gf]=esredist(xa,sigma,gf);
%
% Evolution Strategy's REDISTribute the current population at random

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin ~=3,
   error('Three input arguments required?')
end

index=randperm(size(gf,2));
xa=xa(:,index);sigma=sigma(:,index);gf=gf(:,index);




  

