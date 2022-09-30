function sampl=obj2spl(obj,sec_num,ind_num,expo)
% sampl=obj2spl(obj,sec_num,ind_num,expo)
% This function is used to rank the current population
% using the objective values.
%
% Inputs:
%   obj     - objective values (matrix) 
%   sec_num - number of sections for each objective value
%   ind_num - number of individuals that must be chosen
%             for each objective value
%   expo    - expo = 1 for linear ranking
%             expo > 1 for non-linear ranking
%
% Output:
%   sampl   - index-vector for individuals that are chosen.

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 


[mf,Npop]=size(obj);
bound=[min(obj');max(obj')];
bound=[bound;(bound(2,:)-bound(1,:))/(sec_num^expo)];

index=[1:Npop];  
sampl=[];       % contents all sample index
for j=1: mf,
   index1=index; 
   if ~isempty(sampl), index1(sampl)=[]; end
   indnum=0;
   for i=1:sec_num,
      objtmp=obj(j,index1);btmp=bound(:,j);
      tmp=find(objtmp >=btmp(1)+((i-1)^expo)*btmp(3) & objtmp <btmp(1)+(i^expo)*btmp(3)) ;
      if ~isempty(tmp),
         [minobj,tmp1]=min(objtmp(tmp));sampl=[sampl,index1(tmp(tmp1(1)))]; 
         index1(tmp)=[]; indnum=indnum+1;
      end
      if indnum > ind_num, break, end  
   end      
end   


