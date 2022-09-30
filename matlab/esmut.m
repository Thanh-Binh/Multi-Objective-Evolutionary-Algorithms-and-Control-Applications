function [xa,sigma,gf,MutationSuccess]=esmut(x,xrange,xa,sigma,gf,par,FunName,Algorithm);
% [xa,sigma,gf,MutationSuccess]=esmut(x,xrange,xa,sigma,gf,par,FunName,Algorithm);
% par=[ES.parameter, ConstSatisfy];


xout        = x(:); 
SigmaMin    = 1e-5;
PopSize     = par(1);
NumMut      = par(4);
NumOffsMut  = par(5);
Distrib     = par(13);
ConstSatisfy= par(21);
nvars       = length(xout);
mf          = size(gf,1)-1;
alpha       = .25^(1/nvars); % descreasing the strategy parameters
alpha1      = .04^(1/nvars); % increasing the strategy parameters

if alpha >.96, alpha=.96;end
if alpha1 >.9, alpha1=.9;end

[xa,sigma,gf]=esredist(xa,sigma,gf); 
                                                               
if ConstSatisfy,
   if mf>1,
      nwwindex=recpair(PopSize,1,NumMut,Distrib);
   else,
      nwwindex=recpair(PopSize,1,NumMut,Distrib);
      if mf==1,
        [gftmp,idxtmp]=sort(gf(2,:));
        nwwindex(1:2)=idxtmp(1:2);
      end
   end
   UF_best_g=par(20);
else                                 
   satisfy_ind=find(gf(1,:)==0); 
   num_satisfy_ind=length(satisfy_ind);
   if num_satisfy_ind, 
      if ~mf, 
         if num_satisfy_ind > NumMut,
            nwwindex=recpair(num_satisfy_ind,1,NumMut,Distrib);
            nwwindex=satisfy_ind(nwwindex);
         elseif num_satisfy_ind==NumMut,
            nwwindex=satisfy_ind;
         else,
            nwwindex=recpair(PopSize,1,NumMut-num_satisfy_ind,Distrib);
            nwwindex=[satisfy_ind,nwwindex]; 
         end
      else,
         if mf ==1,
            [gftmp,idxtmp]=sort(gf(2,satisfy_ind));
            satisfy_ind=satisfy_ind(idxtmp);
         end
         FNum2mut=min([num_satisfy_ind,floor(.7*NumMut)]);
         UFNum2mut=NumMut-FNum2mut;
         Findex=satisfy_ind(1:FNum2mut);
         nwwindex=[1:PopSize];nwwindex(Findex)=[];
         idxtmp=randperm(PopSize-FNum2mut);nwwindex=nwwindex(idxtmp);
         nwwindex=[Findex,nwwindex(1:UFNum2mut)];
      end
   else,
      nwwindex=recpair(PopSize,1,NumMut,Distrib);
      [gftmp,idxtmp]=min(gf(1,:));
      nwwindex(1)=idxtmp;
   end
   % find the best unfeasible individuals in the current population
   % which is used to decide if unfeasible offstring is viable.
   UF_best=find(gf(1,:)~=0);UF_best_g=max([par(20),gf(1,UF_best)]);
end

if strcmp(Algorithm,'SelfAdapt')
   % Self-adaptation Mutation
   Par=[nvars,mf,NumMut,NumOffsMut,par(10),ConstSatisfy,UF_best_g,par(18),alpha,alpha1,1e-5];
   [xa,sigma,gf,MutationSuccess]=esmutsa(x,xa,sigma,gf,nwwindex,xrange,FunName,Par);

elseif strcmp(Algorithm,'Integer'),
   Par=[nvars,mf,NumMut,NumOffsMut,par(10),ConstSatisfy,UF_best_g,par(18),alpha,alpha1,1e-5];
   [xa,sigma,gf,MutationSuccess]=esmutint(x,xa,sigma,gf,nwwindex,xrange,FunName,Par);
end
%

