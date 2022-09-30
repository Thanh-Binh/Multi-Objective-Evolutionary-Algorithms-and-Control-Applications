function [ap,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata]= bhinf_sp(p,nmeas,ncon)
%[ap,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata]= bhinf_sp(p,nmeas,ncon)
%
%   split up the H-infinity matrices
%

% To Thanh Binh IFAT Uni. Magdeburg Germany
% All Rights Reserved 2.8.95

%
[pptype,npout,npin,np] = minfo(p);
if pptype ~= 'syst'
  error('matrix is not a system matrix')
end
np1 = npout-nmeas;
np2 = nmeas;
nm1 = npin-ncon;
nm2 = ncon;
ndata = [np1 np2 nm1 nm2];
[ap,bp,cp,dp] = unpck(p);

%
% the following formulars are unknown
dum = sqrt(norm(bp,'inf')/norm(cp,'inf'));
bp = bp/dum; % Why?
cp = cp*dum; % Why?
%

b1 = bp(:,[1:nm1]);
b2 = bp(:,[(nm1+1):npin]);
c1 = cp([1:np1],:);
c2 = cp([(np1+1):npout],:);
d11 = dp(1:np1,1:nm1);
d12 = dp(1:np1,(nm1+1):npin);
d21 = dp((np1+1):npout,1:nm1);
d22 = dp((np1+1):npout,(nm1+1):npin);
