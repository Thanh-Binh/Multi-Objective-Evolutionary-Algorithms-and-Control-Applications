function [xn,sn,gfn,resfn,x1,s1,g1,resf1]=evselect(xn,sn,gfn,resfn,resftest,where)
% [xn,sn,gfn,resfn,x1,s1,g1,resf1]=evselect(xn,sn,gfn,resfn,resftest,where)
%
% To choose the better individuals by optimization with strict and not-strict 
% restrictions. if all current not-strict restrictions are not satisfied, 
% it returns resfn for creating the resfbound for the next generations
%
% resftest=1 <====> resfn is not empty matrix including all restrictions
%                   Individuals have 4 specifications
% resftest=2 <====> resfn hat the value -1 (alle the Indiv. have the same
%                   living conditions and need not to change resfn)
%                   Individuals have 3 specifications
%
% The forth character of a individual (a life condition) is only used if
% the desired life condition is not achieved
%
% where = 0 for using this routine by the reproduction
%           not return the values of x1, s1,g1,resf1
% where = 1 used by selection
%
%
% See also: REPROD.M, SELECT2.M

% All Rights Reserved, March 1996  
% To Thanh Binh IFAT Uni. of Magdeburg Germany


[mf,lgf]=size(gfn);
if where, 
   g1=[];s1=[];x1=[]; 
   if resftest ==1, 
      resf1=[]; 
   else 
      resf1=-1; 
   end
end

it=1;test=1;
while test,
  j=1;
  while (j<=lgf),
    if (it~=j)&(it<=lgf),
       itest=length(find(gfn(:,j)-gfn(:,it) >=0));
       if itest==mf,
          if where,
             g1=[g1,gfn(:,j)];s1=[s1,sn(:,j)];x1=[x1,xn(:,j)];
             if resftest ==1, 
                resf1=[resf1,resfn(:,j)]; 
             end 
          end
          gfn(:,j)=[];sn(:,j)=[];xn(:,j)=[];
          if resftest ==1, resfn(:,j)=[];end
          lgf=lgf-1 ;
       elseif itest==0,
          if where,
             g1=[g1,gfn(:,it)];s1=[s1,sn(:,it)];x1=[x1,xn(:,it)];
             if resftest ==1, 
                resf1=[resf1,resfn(:,it)]; 
             end 
          end
          gfn(:,it)=gfn(:,j);sn(:,it)=sn(:,j);xn(:,it)=xn(:,j);
          gfn(:,j)=[];sn(:,j)=[];xn(:,j)=[];
          if resftest ==1, 
             resfn(:,it)=resfn(:,j); resfn(:,j)=[];
          end
          lgf=lgf-1;
       else
          j=j+1;
       end
    else
       j=j+1;
    end
  end
  if it<lgf-1,it=it+1;else test=0;end
end
