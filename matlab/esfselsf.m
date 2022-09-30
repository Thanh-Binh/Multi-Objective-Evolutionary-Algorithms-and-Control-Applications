function  [xa,sigma,gf,xmin,xmax]=esfselsf(xa,sigma,gf,Nfeasible,N_niches,beta);
% [xa,sigma,gf,xmin]=esfselsf(xa,sigma,gf,Nfeasible,N_niches,beta);
% Evolution Strategy's SELection for Scalar Optimization the better
% Feasible individuals from the feasible population
%
% Inputs:
%    XA            - Current population in parameter space
%    SIGMA         - Current population in strategy parameter space
%    GF            - Current population in objective space
%    NFEASIBLE     - Number of the feasible individuals
%    N_NICHES      - Number of the niche individuals
%    BETA          - Factor for choosing niche individuals
%
% Outputs:
%    XMIN          - The best individual in parameter space
%    XMAX          - The worst individual in parameter space


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin ~=6,
   error('Six input arguments required?')
end

[nvars,npop]=size(xa);
gf=gf(2,:);
[gf,isort]=sort(gf);
xa=xa(:,isort);sigma=sigma(:,isort);
xmin=xa(:,1);
xmax=xa(:,npop);

if (nvars > 10) & (nvars <= 20), 
   beta=beta/10; 
elseif (nvars > 20) & (nvars <= 30), 
   beta=beta/20;
elseif (nvars > 30), 
   beta=beta/20;
end

qei=0;id=0;
for i=2:npop;,
   if xa(:,i)~=xmin,
      xx=xa(:,i)-xmin;id=[id,i];
      qei1=(gf(i)-gf(1))/((sum(xx.^2))^beta);
      %qei1=(gf(i)-gf(1))/norm(xx,2);
      qei=[qei,qei1];
   end
end
qei(1)=[];id(1)=[];Index=[1:npop];
lid=length(id); 
if lid,
   if N_niches>=lid,
      N_niches=lid;
   else
      [qein,isort]=sort(qei);id=id(isort);
   end
   id=id(1:N_niches);
   Index(id)=[];
   Index=[id,Index(1:Nfeasible-N_niches)];
else,
   Index=Index(1:Nfeasible);
end
xa=xa(:,Index);sigma=sigma(:,Index);gf=[zeros(1,Nfeasible);gf(Index)];

%[gfmax,imax]=max(gf(2,:));xmax=xa(:,imax);

  

