function  [xa_uf,sigma_uf,gf_uf]=esfselsu(xa_uf,xa_fmin,xa_fmax,sigma_uf,gf_uf,Nunfeasible,N_uniches,beta,relax)
% [xa_uf,sigma_uf,gf_uf]=esfselsu(xa_uf,xa_fmin,sigma_uf,gf_uf,Nunfeasible,N_uniches,beta,relax)
%
% Evolution Strategy's Feasible SELection by Searching only for 
% the feasible Region: select Unfeasible individuals
%
% Inputs:
%    XA_UF         - unfeasible subpopulation in parameter space
%    XA_FMIN       - the best feasible individual in parameter space
%    XA_FMAX       - the worst feasible individual in parameter space
%    SIGMA_UF      - unfeasible subpopulation in strategy parameter space
%    GF_UF         - unfeasible subpopulation in objective space
%    NUNFEASIBLE   - Number of the unfeasible individuals
%    N_UNICHE      - Number of the unfeasible niche individuals
%    BETA          - Factor for choosing niche individuals
%    RELAX         - Relaxing factor for feasible region
 

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


[tmp,isort]=sort(gf_uf(1,:));
xa_uf=xa_uf(:,isort);sigma_uf=sigma_uf(:,isort);
gf_uf=gf_uf(:,isort);
Weighting=.7;          % for Niche Type 1
Tol=relax;             % relaxing factor for feasible region

[nvars,npop]=size(xa_uf);
xa_fmin=xa_fmin(1:nvars,ones(1,npop));
xa_fmax=xa_fmax(1:nvars,ones(1,npop));
% Distance of the infeasible individuals from the best and the worst
% feasible individuals

dist_min=sum((xa_uf-xa_fmin).^2);
dist_max=sum((xa_uf-xa_fmax).^2);

% Niche type 1 is nearer to the best feasible individual than the worst
% then we choose only indiv. more far from the worst
Type1_indx=find(dist_min <= dist_max);
NumType1=length(Type1_indx);  % current number of the niche individuals Type 1

Index=[1:npop];
% Niche type 2 is more next to the worst feasible individual than the best
% then we choose only indiv. more far from the best
Type2_indx=Index; Type2_indx(Type1_indx)=[];
NumType2=npop-NumType1;       % current number of the niche individuals Type 2

NType2=floor(.4*N_uniches);   % desired number of the niche individuals Type 2
NType1=N_uniches-NType2;      % desired number of the niche individuals Type 1

if NumType1<=NType1,          % save niche Indiv. Type 1 (it is very little)
                              % include more Indiv. Type 2
   NicheFit=max([tmp(Type2_indx);Tol*ones(1,NumType2)]);
   %NicheFit=tmp(Type2_indx);
   NicheVal2=NicheFit./(Weighting*dist_min(:,Type2_indx)+(1-Weighting)*dist_max(:,Type2_indx));
   [tmp,Niche_indx]=sort(NicheVal2);
   Niche_indx=[Type1_indx,Niche_indx(1:N_uniches-NumType1)];
     
else
   if NumType2 > NType2,      % niche individuals of both Type 1 and Type 2
      NicheFit=max([tmp(Type1_indx);Tol*ones(1,NumType1)]);
      %NicheFit=tmp(Type1_indx);
      NicheVal1=NicheFit./((1-Weighting)*dist_min(:,Type1_indx)+Weighting*dist_max(:,Type1_indx));
      [tmp1,NicheType1]=sort(NicheVal1);

      NicheFit=max([tmp(Type2_indx);Tol*ones(1,NumType2)]);
      %NicheFit=tmp(Type2_indx);
      NicheVal2=NicheFit./(Weighting*dist_min(:,Type2_indx)+(1-Weighting)*dist_max(:,Type2_indx));
      [tmp2,NicheType2]=sort(NicheVal2);
      Niche_indx=[NicheType1(1:NType1),NicheType2(1:NType2)];

   else,                       % save Indiv. Type 2 (it is very little)
                               % include more Indiv. Type 1
      NicheFit=max([tmp(Type1_indx);Tol*ones(1,NumType1)]);
      %NicheFit=tmp(Type1_indx);
      NicheVal1=NicheFit./((1-Weighting)*dist_min(:,Type1_indx)+Weighting*dist_max(:,Type1_indx));
      [tmp,Niche_indx]=sort(NicheVal1);
      Niche_indx=[Type2_indx,Niche_indx(1:N_uniches-NumType2)];
   end
end   
Index(Niche_indx)=[];
Index=[Niche_indx,Index(1:(Nunfeasible-N_uniches))];
xa_uf=xa_uf(:,Index);sigma_uf=sigma_uf(:,Index);
gf_uf=gf_uf(:,Index);
  
