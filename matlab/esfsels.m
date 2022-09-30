function  [xa,sigma,gf]=esfsels(xa,sigma,gf,FeasibleInd,UnfeasibleInd,nI,N_uniches,N_niches,Ncurrent,beta,NicheMethod,relax);
% [xa,sigma,gf]=esfsels(xa,sigma,gf,FeasibleInd,UnfeasibleInd,nI,N_uniches,N_niches,Ncurrent,beta,NicheMethod,relax);
%
% Evolution Strategy's Feasible individuals SELection for the Single-objective
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
%    NICHEMETHOD   - Niche method 


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin ~=12,
   error('Twelve input arguments required?')
end

FNum=length(FeasibleInd);UFNum=Ncurrent-FNum;

xa_f=xa(:,FeasibleInd);sigma_f=sigma(:,FeasibleInd);gf_f=gf(:,FeasibleInd);
xa_uf=xa(:,UnfeasibleInd);sigma_uf=sigma(:,UnfeasibleInd);gf_uf=gf(:,UnfeasibleInd);

Nfeasible=nI-N_uniches;

if FNum >= Nfeasible,      
   if UFNum >= N_uniches
       NumUF=N_uniches; NumF=Nfeasible;
       Case=11;
   else,
       NumF=Nfeasible+(N_uniches-UFNum);
       Case=10;
   end
else,
   if UFNum >= N_uniches
       NumUF=N_uniches+(Nfeasible-FNum); NumF=FNum;
       Case=1;  % exactly 01;
   end
end 

if Case==1,
   if FNum,
      [gftmp,indx]=sort(gf_f(2,:)); xa_fmin=xa_f(:,indx(1));xa_fmax=xa_f(:,indx(FNum));
       % choose  NumUF of unfeasible ind. (includes N_uniches of unfeasible indiv. for the
       % best feasible individual) from the unfeasible pop.
      [xa_uf,sigma_uf,gf_uf]=esfselsu(xa_uf,xa_fmin,xa_fmax,sigma_uf,gf_uf,NumUF,N_uniches,beta,relax);
   else,
      if ~NicheMethod, 
         [gftmp,indx]=sort(gf_uf(1,:));indx=indx(1:NumUF);
         xa_uf=xa_uf(:,indx);sigma_uf=sigma_uf(:,indx);gf_uf=gf_uf(:,indx);
      else,
         [xa_uf,sigma_uf,gf_uf]=esusel(xa_uf,sigma_uf,gf_uf,NumUF,N_niches,beta); 
      end 
   end

elseif Case==10,
 
   % choose more than Nfeasible of feasible ind. from the feasible subpopulation
   [xa_f,sigma_f,gf_f,xa_fmin,xa_fmax]=esfselsf(xa_f,sigma_f,gf_f,NumF,N_niches,beta);

elseif Case==11,

   % choose Nfeasible of feasible ind. from the feasible subpopulation
   [xa_f,sigma_f,gf_f,xa_fmin,xa_fmax]=esfselsf(xa_f,sigma_f,gf_f,NumF,N_niches,beta);

   % choose more than N_uniches of unfeasible ind. from the unfeasible pop.
   [xa_uf,sigma_uf,gf_uf]=esfselsu(xa_uf,xa_fmin,xa_fmax,sigma_uf,gf_uf,NumUF,N_uniches,beta,relax);

end
xa=[xa_f,xa_uf];sigma=[sigma_f,sigma_uf];gf=[gf_f,gf_uf];


% insert the niches into the population at random
[xa,sigma,gf]=esredist(xa,sigma,gf);

