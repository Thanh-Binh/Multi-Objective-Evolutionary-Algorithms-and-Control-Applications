function [xn,sn,gfn,x1,s1,g1]=noninfsl(xn,sn,gfn)
% [xn,sn,gfn,x1,s1,g1]=noninfsl(xn,sn,gfn)
% NONINFerior SeLection for the MultiObjective Optimization
%
% Inputs:
%    XN   - Population in parameter space
%    SN   _ Population in strategy parameter space 
%    GFN  - Population in objective space
%
% Outputs:
%    (XN, SN, GFN) - non-inferior subpopulation
%    (X1, S1, GF1) - the other subpupolation
%
% See also: ESREPROD.M, ESELECT2.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 


[mf,lgf]=size(gfn);
g1=[];s1=[];x1=[]; 

it=1;test=1;
while test,
  j=1;
  while (j<=lgf),
    if (it~=j)&(it<=lgf),
       itest=length(find(gfn(:,j)-gfn(:,it) >=0));
       if itest==mf,
          g1=[g1,gfn(:,j)];s1=[s1,sn(:,j)];x1=[x1,xn(:,j)];
          gfn(:,j)=[];sn(:,j)=[];xn(:,j)=[];
          lgf=lgf-1 ;
       elseif itest==0,
          g1=[g1,gfn(:,it)];s1=[s1,sn(:,it)];x1=[x1,xn(:,it)];
          gfn(:,it)=gfn(:,j);sn(:,it)=sn(:,j);xn(:,it)=xn(:,j);
          gfn(:,j)=[];sn(:,j)=[];xn(:,j)=[];
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
