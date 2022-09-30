function  [xa,sigma,gf]=esusel(xa,sigma,gf,nI,N_niches,beta);
% [xa,sigma,gf]=esusel(xa,sigma,gf,nI,N_niches,beta);
% Evolution Strategy's Unfeasible SELection for scalar optimization 


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany

if nargin ~=6,
   error('Six input arguments required?')
end

[nvars,npop]=size(xa);
[gftmp,isort]=sort(gf(1,:));
xa=xa(:,isort);sigma=sigma(:,isort);

%beta=beta/nvars;

qei=0;id=0;
for i=2:npop;,
   if xa(:,i)~=xa(:,1),
      xx=xa(:,i)-xa(:,1);id=[id,i];
      %qei1=(gftmp(i)-gftmp(1))/((sum(xx.^2))^beta);
      qei1=(gftmp(i)-gftmp(1))/norm(xx,2);
      qei=[qei,qei1];
   end
end
qei(1)=[];id(1)=[];Index=[1:npop];
lid=length(id); 
if lid,
   if N_niches>lid,
      N_niches=lid;
   else
      [qein,isort]=sort(qei);id=id(isort);
   end
   id=id(1:N_niches);
   Index(id)=[];
   Index=[id,Index(1:nI-N_niches)];
else,
   Index=Index(1:nI);
end
xa=xa(:,Index);sigma=sigma(:,Index);gf=gf(:,Index);

% insert the niches into the population at random
[xa,sigma,gf]=esredist(xa,sigma,gf);

  

