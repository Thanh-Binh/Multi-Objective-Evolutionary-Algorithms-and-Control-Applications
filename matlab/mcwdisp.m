function mcwdisp(gf,iter)
% mcwdisp(gf,iter)
% To display intermediate results of the Optimization Routine
% in the MATLAB Command Window 
% 
% Input:
%    iter           -  the current iteration
%    gf             -  objective function vector
%
% For the scalar optimization, the smallest value of gf is displayed.
% For the vector optimization, display two rows:
%   - in the first row, for the smallest values of all obj.functions
%   - in the second row, for the biggest values of all obj.functions


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


[mf,nI]=size(gf);
gmax=max(gf(1,:));gmin=min(gf(1,:));
Findex=find(gf(1,:)==0);
if isempty(Findex),
   gmax=[gmax,Inf*ones(1,mf-1)];gmin=[gmin,Inf*ones(1,mf-1)];
else,
   if mf > 1
      gmax=[gmax,(max(gf(2:mf,Findex),[],2))'];
      gmin=[gmin,(min(gf(2:mf,Findex),[],2))'];
   end
end

dignum=12;

if ~iter, 
   f=['Iter:',32*ones(1,3)];
   for i=1:mf, 
      if i>9, spaces=32*ones(1,dignum+2);else spaces=32*ones(1,dignum+1);end
      if i==1,
         f=[f, 'CDist',32*ones(1,dignum-2)];
      else,
         f=[f, 'f', int2str(i-1),spaces];
      end
   end   
   disp(' ');disp(f);
end
    
if iter <10,
   f=[int2str(iter),32*ones(1,7)]; 
elseif (iter >=10)&(iter<100),
   f=[int2str(iter),32*ones(1,6)]; 
elseif (iter >=100)&(iter<1000),
   f=[int2str(iter),32*ones(1,5)]; 
else,
   f=[int2str(iter),32*ones(1,4)]; 
end   
f1=32*ones(1,8);
for i=1:mf, 
   tmp =num2str(gmin(i),'%7.6g'); tmpl=length(tmp);
   tmp1=num2str(gmax(i),'%7.6g');tmp1l=length(tmp1); %%7
   if tmpl > dignum,
       tmp=tmp(1:dignum);
   else,
       tmp=[tmp, 32*ones(1,dignum-tmpl)]; 
   end 
   if tmp1l > dignum,
       tmp1=tmp1(1:dignum);
   else,
       tmp1=[tmp1, 32*ones(1,dignum-tmp1l)]; 
   end 
   f=[f,tmp,32*ones(1,3)];f1=[f1,tmp1,32*ones(1,3)];
end        
disp(' ');disp(f);disp(f1); 


