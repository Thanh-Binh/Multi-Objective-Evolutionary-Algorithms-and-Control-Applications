function mcwdispn(gf,iter)
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
   G=[gmin,Inf*ones(1,mf-1);gmax,Inf*ones(1,mf-1)];
else,
   if mf > 1
     G=[gmin,(min(gf(2:mf,Findex),[],2))';... 
        gmax,(max(gf(2:mf,Findex),[],2))'];
   end
end


f=['Gen=',int2str(iter) 32];
for i=1:mf, 
   if i==1,
      f=[f, 'CDist' 32];
   else,
      f=[f, 'f', int2str(i-1) 32];
   end
end   
f1=strpmat(G,['min  ';'max  ']);
    
disp(strvcat(f,f1));


