%FEED2
%       [acl,bcl,ccl1,dcl1,ccl2,dcl2]=feed2b(ag,bg,cg,dg,ak,bk,ck,dk)
%	file to build closed loop for 2 dof configuration
%
%       r (l)   ______   u(m) _____        y(p)
%	-------|Ak Bk |______|a b  |_______
%	    ___|Ck Dk |      |c d  |    |
%	   |   |______|      |_____|    |
%	   |_____________ ______________|
%
%
%	OUTPUT: REALIZATION FROM r to {y,u}
%
%	METHOD: FORMULATES AN EQUIVALENT GENERALIZED REGULATOR AND USES SCC_UN
%
%

% (c) JF Whidborne, King's College London
% 23/4/96

function [acl,bcl,ccl1,dcl1,ccl2,dcl2]=feed2b(ag,bg,cg,dg,ak,bk,ck,dk)
[p,n]=size(cg);
[n,m]=size(bg);
[P,M]=size(dk);
l=M-p;
[N,N]=size(ak);

if P~=m,error(' incompatible dimensions!')
elseif p>=M,error(' incompatible dimensions!')
end

B1=bk(:,1:l);
B2=bk(:,l+1:M);
D1=dk(:,1:l);
D2=dk(:,l+1:M);

%
X2 = inv(eye(m)-D2*dg);
X  = inv(eye(p)-dg*D2);

%	define closed loop plant
acl = [ak+B2*X*dg*ck,  B2*X*cg;
       bg*X2*ck,        ag+bg*X2*D2*cg];
bcl = [B1;
       bg*X2*D1];       
ccl1 = [X*dg*ck,  X*cg];
dcl1 = [zeros(p,l)];

if nargout > 4,
  ccl2 = [X2*ck,    X2*D2*cg];
  dcl2 = [X2*D1];
end
