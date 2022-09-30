function  [xa,sigma,gf]=esfselmf(xn,sn,gfn,nI);
% [xa,sigma,gf]=esfselmf(xn,sn,gfn,nI);
%
% Evolution Strategy's Feasible individuals SELection from a set of
% feasible individuals by the MultiObjective Optimization.
%
% Inputs:
%    XN            - Current population in parameter space
%    SN            - Current population in strategy parameter space
%    GFN           - Current population in objective space
%    NI            - Original Population Size
%
% Outputs:
%    XA            - Next population in parameter space
%    SIGMA         - Next population in strategy parameter space
%    GF            - Next population in objective space


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


gfn(1,:)=[];
[tmp,itmp]=min(gfn');    % find the best individual in the population,
                         % if it exists. That means, the individual
                         % dominates all other individuals.

beta=2;
if ~any(itmp-itmp(1)),   % the best ind. exists
    [radiuc_g1,i]=sort(sum(gfn.^beta));     
    gf=gfn(:,i(1:nI));xa=xn(:,i(1:nI));sigma=sn(:,i(1:nI));
    gf=[zeros(1,nI);gf];
    return,
end

[xn,sn,gfn,x1,s1,g1]=noninfsl(xn,sn,gfn);
                         % gfn includes indifferent Individuen
                         % g1 includes the worse Ind.
[mf,n1]=size(gfn);
if n1< nI,

     [radiuc_g1,i]=sort(sum(g1.^beta));
     I=i(1:nI-n1);        
     gf=[gfn,g1(:,I)];xa=[xn,x1(:,I)];sigma=[sn,s1(:,I)];

elseif n1==nI,
   gf=gfn;xa=xn;sigma=sn;

else
   mbth=1;
   hh=fix(nI/(mf+mbth));
   index=obj2spl(gfn,n1,hh,2);
   tmp=[1:n1];tmp(index)=[];
   [radiuc,ind1]=sort(sum(gfn(:,tmp).^2));
   I=[index,tmp(ind1(1:nI-length(index)))];
   gf=gfn(:,I);xa=xn(:,I);sigma=sn(:,I);
end
gf=[zeros(1,nI);gf];

