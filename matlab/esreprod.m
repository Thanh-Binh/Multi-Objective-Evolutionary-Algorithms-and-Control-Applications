function [xa,sigma,gf]=esreprod(x,xa,sigma,gf,par,FunName,Algorithm);
% [xa,sigma,gf]=esreprod(x,xa,sigma,gf,par,FunName,Algorithm);
%
% Evolution Strategy's reproduction
%
% See Also: EVOLSTR.M
 

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


NumRep          = par(3);
Distrib         = par(13);
ConstSatisfy    = par(21);
MutationSuccess = par(22);

xout =x(:);
nvars=length(xout);

% Algorithm for the reproduction
if strcmp(Algorithm,'Combi'),
   if ~MutationSuccess,
     if rand<.1,
        reprodalg='esreclin';
     else,
        reprodalg='esreclp';
     end
     NumRep=2*NumRep;
   else,
     if rand<.9,
        reprodalg='esxovmp';
     else,
        reprodalg='esreclin'; %'esrecint';
     end
   end

elseif strcmp(Algorithm,'MultiParent'),
   reprodalg='esxovmp';

elseif strcmp(Algorithm,'Arithmetic'),
   reprodalg='esarico';

elseif strcmp(Algorithm,'ExtendedLine'),
   reprodalg='esreclin';

elseif strcmp(Algorithm,'Heuristic'),
   reprodalg='eshxo';   

elseif strcmp(Algorithm,'IntegerCrossOver'),
   reprodalg='esintxo';   

end


[mf,nI]=size(gf);
mf=mf-1;
gtest=zeros(mf,1);

if ConstSatisfy,                 % the goal restrictions are satisfied
   index=[];                     % choose the index-th Individuals
   for i=1:mf,
      gtest(i)=min(gf(i+1,:))+(1-par(8))*(max(gf(i+1,:))-min(gf(i+1,:)));
   end
   for i=1:nI,
      if any(gtest>=gf(2:mf+1,i)), index=[index,i];end
   end 
else,
                                 % search for feasible individuals
   uf_indx=[1:nI];
   f_indx=find(gf(1,:)==0);NFInd=length(f_indx);
   if NFInd, uf_indx(f_indx)=[];end
   if ~mf
      % choose the better from unfeasible individuals
      gtest=min(gf(1,uf_indx))+(1-par(8))*(max(gf(1,uf_indx))-min(gf(1,uf_indx)));
      indx=find(gf(1,uf_indx) <= gtest); 
      index=[f_indx,uf_indx(indx)];
   else,
      if NFInd > .5*(par(1)-par(19)),
         index=uf_indx;                    
         for i=1:mf,
            gtest(i)=min(gf(i+1,f_indx))+(1-.4*par(8))*(max(gf(i+1,f_indx))-min(gf(i+1,f_indx)));
         end
         for i=1:NFInd,
            if any(gtest>=gf(2:mf+1,f_indx(i))), index=[f_indx(i),index];end
         end 
      else
         index=f_indx;                    
         gtest=min(gf(1,uf_indx))+(1-par(8))*(max(gf(1,uf_indx))-min(gf(1,uf_indx)));
         indx=find(gf(1,uf_indx) <= gtest); 
         index=[index,uf_indx(indx)];
      end
   end  
   % the best parents include all the feasible indiv. and the better unfeasible indiv.
   UF_best_g=max([par(20),gf(1,uf_indx)]);

end            

% shuffling all parent at random
index=index(randperm(length(index)));

num_parent=length(index);
x_parent  =xa(:,index);
gf_parent =gf(:,index);
s_parent  =sigma(:,index);

if num_parent>1,   
   parent_index=recpair(num_parent,2,NumRep,Distrib);

   for RepIter=1:NumRep,
      nnew=parent_index(:,RepIter);
      if nnew(1)~=nnew(2),        
         Ox=x_parent(:,nnew);Os=s_parent(:,nnew);
         gf1=gf_parent(:,nnew(1));
         gf2=gf_parent(:,nnew(2));
         if strcmp(Algorithm,'Combi'),
            if (gf1(1)==0 & gf2(1)~=0),
               reprodalg='esarico';
            elseif (gf2(1)==0 & gf1(1)~=0),
               Ox=[Ox(:,2),Ox(:,1)];Os=[Os(:,2),Os(:,1)];
               reprodalg='esarico';
            end
         end

         [Nx,Ns]=feval(reprodalg,Ox,Os);
         for i=1:2,
            x(:)=Nx(:,i);
            gfn=feval(FunName,x); viable=0;
            if ConstSatisfy,
               if ~gfn(1),               % signal for viability is gfn(1)==0
                  if mf,
                     if any(gfn(2:mf+1)< gf1(2:mf+1)) & any(gfn(2:mf+1)< gf2(2:mf+1)), 
                                    % check for viability using  obj. functions
                        viable=1;
                     end
                  else,
                     viable=1;
                  end
               end 
 
            else,                   
                                         % check for viability using  the auxiliary
                                         % function for constraints

               if ~isinf(gfn(1)),        % signal for viability is gfi(1)~=inf
                  if gfn(1)*par(10)<= max([gf1(1) gf2(1)]),  % check viability using constraints
                     viable=1;
                  else
                     if (~min([gf1(1) gf2(1)]))&(gfn(1)*par(10)<=UF_best_g),
                        viable=1;
                     end 
                  end
               end
            end
            if viable, xa=[xa,Nx(:,i)];sigma=[sigma,Ns(:,i)];gf=[gf,gfn];end
         end

      else,                        % reduplication
                 
         xa=[xa,x_parent(:,nnew(1))];sigma=[sigma,s_parent(:,nnew(1))];
         gf=[gf,gf_parent(:,nnew(1))];
      end
   end
elseif num_parent==1,              % only one best indiv. it must generate the same
                                   % number of offsprings
   for i=1:par(3),
      xa=[xa,x_parent];sigma=[sigma,s_parent];gf=[gf,gf_parent];
   end
end

