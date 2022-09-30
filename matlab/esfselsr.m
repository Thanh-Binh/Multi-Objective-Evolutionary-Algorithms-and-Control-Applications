function  [xa,sigma,gf]=esfselsr(xa,sigma,gf,NumInd,NumNiche,beta,NicheMethod);
% [xa,sigma,gf]=esfselsr(xa,sigma,gf,NumInd,NumNiche,beta,NicheMethod);
% Evolution Strategy's Feasible SELection for Searching only for 
% the feasible Region
%
% Inputs:
%    XA            - Current population in parameter space
%    SIGMA         - Current population in strategy parameter space
%    GF            - Current population in objective space
%    NUMIND        - Original Population Size
%    NUMNICHE      - Number of the niche individuals
%    BETA          - Factor for choosing niche individuals
%    NICHEMETHOD   - Niche method 


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin ~=7,
   error('Seven input arguments required?')
end

[nvars,npop]=size(xa);

FIndx=find(gf(1,:)==0);  % index for feasible individuals
FNum=length(FIndx);      % number of the feasible indiv.

if FNum >= NumInd,
   FIndx=FIndx(1:NumInd);
   xa=xa(:,FIndx);sigma=sigma(:,FIndx);gf=gf(:,FIndx);
   return,
end
if FNum,
   xa_f=xa(:,FIndx);sigma_f=sigma(:,FIndx);gf_f=gf(:,FIndx);
else,
   xa_f=[];sigma_f=[];gf_f=[];
end

UFNum=npop-FNum;
UNumInd=NumInd-FNum;      % number of the rest unfeasible indiv. 
                          % need to be chosen

UFIndx=find(gf(1,:)~=0);  % index for unfeasible individuals

[gftmp,isort]=sort(gf(1,UFIndx));
UFIndx=UFIndx(isort);
xa_uf=xa(:,UFIndx);sigma_uf=sigma(:,UFIndx);gf_uf=gf(:,UFIndx);


if ~NicheMethod,
   xa=[xa_f,xa_uf(:,1:UNumInd)];sigma=[sigma_f,sigma_uf(:,1:UNumInd)];
   gf=[gf_f,gf_uf(:,1:UNumInd)];
   
else,

   if (nvars > 10) & (nvars <= 20), 
      beta=beta/10; 
   elseif (nvars > 20) & (nvars <= 30), 
      beta=beta/20;
   elseif (nvars > 30), 
      beta=beta/20;
   end
   if UNumInd <=NumNiche,
      UFIndx=[1:UNumInd];
      xa_uf=xa_uf(:,UFIndx);sigma_uf=sigma_uf(:,UFIndx);gf_uf=gf_uf(:,UFIndx);

   else,
      if ~FNum,
         qei=[];id=[];

         for i=2:UFNum,
            if xa_uf(:,i)~=xa_uf(:,1),
               xx=xa_uf(:,i)-xa_uf(:,1);id=[id,i];
               qei1=(gftmp(i)-gftmp(1))/((sum(xx.^2))^2);
               %qei1=(gftmp(i)-gftmp(1))/norm(xx,2);
               qei=[qei,qei1];
            end
         end
      else,
         % the center of the feasible individuals
         if FNum>1,
            fxcenter=(sum(xa_f')/FNum)';
         else,
            fxcenter=xa_f;
         end
         fxcenter=fxcenter(1:nvars,ones(1,UFNum));
         id=[1:UFNum];
         %qei=gftmp./sqrt(sum((xa_uf-fxcenter).^2));
         qei=gftmp./((sum((xa_uf-fxcenter).^2)).^2);
      end
      lid=length(id); Index=[1:UFNum];
      if lid,
         if NumNiche>=lid,
            NumNiche=lid;
         else,
            [qein,isort]=sort(qei);id=id(isort);
         end
         id=id(1:NumNiche);
         Index(id)=[];
         Index=[id,Index(1:UNumInd-NumNiche)];
      else,
         Index=Index(1:UNumInd);
      end
      xa_uf=xa_uf(:,Index);sigma_uf=sigma_uf(:,Index);
      gf_uf=gf_uf(:,Index);
   end
   xa=[xa_f,xa_uf];sigma=[sigma_f,sigma_uf];gf=[gf_f,gf_uf];
end

% insert the niches into the population at random
[xa,sigma,gf]=esredist(xa,sigma,gf);
