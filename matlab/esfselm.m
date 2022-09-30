function  [xa,sigma,gf]=esfselm(xa,sigma,gf,FeasibleInd,UnfeasibleInd,nI,N_uniches,N_niches,Ncurrent,beta);
% [xa,sigma,gf]=esfselm(xa,sigma,gf,FeasibleInd,UnfeasibleInd,nI,N_uniches,N_niches,Ncurrent,beta);
%
% Evolution Strategy's Feasible individuals SELection for the Multiobjective
% Optimization in the case both feasible and unfeasible individuals exist
%
% Inputs:
%    XA            - Current population in parameter space
%    SIGMA         - Current population in strategy parameter space
%    GF            - Current population in objective space
%    FEASIBLEIND   - index for feasible individuals
%    UNFEASIBLEIND - index for unfeasible individuals
%    NI            - Original Population Size
%    N_UNICHES     - Number of the unfeasible niche individuals
%    N_NICHES      - Number of the feasible niche individuals
%    NCURRENT      - Current Population Size
%    BETA          - Factor for choosing niche individuals


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin ~=10,
   error('Ten input arguments required?')
end

FNum=length(FeasibleInd);UFNum=Ncurrent-FNum;
Nunfeasible=min([N_uniches,UFNum]);
Nfeasible=nI-Nunfeasible;

xa_f=xa(:,FeasibleInd);sigma_f=sigma(:,FeasibleInd);gf_f=gf(:,FeasibleInd);

if Nunfeasible,

   xa_uf=xa(:,UnfeasibleInd);sigma_uf=sigma(:,UnfeasibleInd);gf_uf=gf(:,UnfeasibleInd);
   if FNum >= Nfeasible,
 
      % choose Nfeasible of feasible ind. from the feasible subpopulation
      [xa_f,sigma_f,gf_f]=esfselmf(xa_f,sigma_f,gf_f,Nfeasible);

      if UFNum > N_uniches, 
         % choose only N_uniches of unfeasible ind. next to the unfeasible pop.
         [gftmp,isort]=sort(gf_uf(1,:));
         xa_uf=xa_uf(:,isort);sigma_uf=sigma_uf(:,isort);gf_uf=gf_uf(:,isort);
         xa_uf=xa_uf(:,1:N_uniches);sigma_uf=sigma_uf(:,1:N_uniches);gf_uf=gf_uf(:,1:N_uniches);
      end
      
   else,
 
      Nunfeasible=nI-FNum;
      % choose only N_uniches of unfeasible ind. next to the unfeasible pop.
      [gftmp,isort]=sort(gf_uf(1,:));
      xa_uf=xa_uf(:,isort);sigma_uf=sigma_uf(:,isort);gf_uf=gf_uf(:,isort);
      xa_uf=xa_uf(:,1:Nunfeasible);sigma_uf=sigma_uf(:,1:Nunfeasible);gf_uf=gf_uf(:,1:Nunfeasible);
   end
   xa=[xa_f,xa_uf];sigma=[sigma_f,sigma_uf];gf=[gf_f,gf_uf];

else,
   [xa,sigma,gf]=esfselmf(xa_f,sigma_f,gf_f,Nfeasible);
 
end

% insert the niches into the population at random
[xa,sigma,gf]=esredist(xa,sigma,gf);
