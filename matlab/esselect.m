function  [xa,sigma,gf]=esselect(xa,sigma,gf,par,Algorithm);
% [xa,sigma,gf]=esselect(xa,sigma,gf,par,Algorithm);
% Evolution SELECTion to search for the Feasible region
%
% In this version, some of the unfeasible individuals lying
%    + next to the feasible region, but so far from
%      the current feasible minimum
%    + or next to the current feasible minimum
% can live in the next generations and can be described
% as the niche unfeasible individuals.
%
% Reasons: these niche unfeasible individuals can generate 
% the feasible offsprings, directly next to the global
% feasible minimum.



PopSize      = par(1);
N_niches     = par(2);       % Number of the feasible niches
beta         = par(11);
N_uniches    = par(19);      % Number of the unfeasible niches
ConstSatisfy = par(21);
NicheMethod  = par(23);

[nvars,Ncurrent]=size(xa);
mf=size(gf,1)-1;

if ConstSatisfy,         % feasible region is found
   if mf ==1,
      [xa,sigma,gf]=esfselsf(xa,sigma,gf,PopSize,N_niches,beta);
   elseif mf >1,
      [xa,sigma,gf]=esfselmf(xa,sigma,gf,PopSize);
   end

else,                    % all given restrictions are not satisfied. To rank    
                         % current population we use the following priorities:
                         %    1- feasible indiv.
                         %    2- individuals next to the feasible region
                         %    3- PopSizeche indivi. (feasible and unfeasible)

   if mf<1,              % only feasible region searching
      [xa,sigma,gf]=esfselsr(xa,sigma,gf,PopSize,N_niches+N_uniches,beta,NicheMethod); 

   else,
      FeasibleInd=find(gf(1,:)==0);

      if length(FeasibleInd),  % Feasible individuals exist

         UnfeasibleInd=[1:Ncurrent];UnfeasibleInd(:,FeasibleInd)=[];
         if mf==1,
            [xa,sigma,gf]=esfsels(xa,sigma,gf,FeasibleInd,UnfeasibleInd,PopSize,...
                     N_uniches,N_niches,Ncurrent,beta,NicheMethod,par(20));
         elseif mf >1,
            [xa,sigma,gf]=esfselm(xa,sigma,gf,FeasibleInd,UnfeasibleInd,PopSize,...
                     N_uniches,N_niches,Ncurrent,beta);
         end

      else,                    % No Feasible individuals exist
                               % selection using the distances
         if ~NicheMethod, 
            [gftmp,gindx]=sort(gf(1,:));gindx=gindx(1:PopSize);
            xa=xa(:,gindx);sigma=sigma(:,gindx);gf=gf(:,gindx);
         else,
            [xa,sigma,gf]=esusel(xa,sigma,gf,PopSize,N_niches,beta); 
         end
      end
   end
   
end

