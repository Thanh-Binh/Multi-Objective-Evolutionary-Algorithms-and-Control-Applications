function [ap,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata,r12,r21,fail,gam] = bhinf_st(p,nmeas,ncon)
%  
%	[ap,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata,r12,r21,fail,gam] = bhinf_st(p,nmeas,ncon)
%
%	scale the d12 and d21 matrices to satisfy the formulas
%       check  ===> the rank conditions.
%              ===> the 1st if-and-only-if-condition
%       The value for the 1st condition is used as value of objective
%       function for h-infinity controller 
%
%       after bhinfgam-function we must check the condition for
%             spectral radius rho(xinf, yinf) < gam^2.
%       d22 can not be changed.

% To Thanh Binh IFAT Uni. Magdeburg Germany
% All Rights Reserved 2.8.95


fail=0;
[ap,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata] = bhinf_sp(p,nmeas,ncon);
np1 = ndata(1);
np2 = ndata(2);
nm1 = ndata(3);
nm2 = ndata(4);
                             % determine if   |A-jwI  b2 | has full column rank at w=0
                             %                |  c1   d12|
                             %
                             %  when yes, the 1st assumption is satisfied
tmp_col=[ap b2;c1 d12];

[nr,nc]=size(tmp_col);
irank = rank(tmp_col,eps);
if irank ~= nc
   fail = 1;                 % the 1st assumption is not satisfied
   return
end
                             % determine if   |A-jwI  b1 | has full row rank at w=0
                             %                |  c2   d21|
                             %
                             %  when yes, the 2nd assumption is satisfied
tmp_row=[ap b1;c2 d21];
[nr,nc]=size(tmp_row);
irank = rank(tmp_row,eps);
if irank ~= nr
   fail = 1;                 %  the 2nd assumption is not satisfied
   return
end
                             %  scale the matrices to    q12*d12*r12 = | 0 |
                             %                                         | I |
[q12,r12] = qr(d12);

                             % determine if d12 has full column rank
                             %
                             %  when yes, the 3rd assumption is satisfied
irank = rank(r12,eps);
if irank ~= nm2
   fail = 1;                 % the 3rd assumption is not satisfied
   return
end
q12 = [q12(:,(nm2+1):np1),q12(:,1:nm2)]';
r12 = inv(r12(1:nm2,:));

                             %   scale the matrices to   r21*d21*q21 = [0 I]
                             %
[q21,r21] = qr(d21');

                             % determine if d21 has full column rank
                             %
                             %  when yes, the 4th assumption is satisfied
irank = rank(r21,eps);
if irank ~= np2
   fail = 1;                 % the first assumption is not satisfied
   return
end
                             % check the 1st if-and-only-if-condition to exist an internally stabilizing 
                             % controller such that the infinity norm of the linear fractional map is
                             % bounded above by gamma
                             % Instead, for optimizations we want to use this above bound as the value
                             % of the objective function for H-infinity problem.
                             % To do it we perform 3 steps:
                             %        1. patition d11
                             %                          _____                  _____
                             %        2. calculate  max(sigma([d1111, d1112]), sigma([d1111', d1121']))
                             %
                             %        3. assign this value to gamm+1e-5;

                             %  step 1
                             
d1111=d11(1:(np1-nm2),1:(nm1-np2));
d1112=d11(1:(np1-nm2),(nm1-np2+1):nm1);
d1121=d11((np1-nm2+1):np1,1:(nm1-np2));
d1122=d11((np1-nm2+1):np1,(nm1-np2+1):nm1);
                             
                             % step 2 and 3

gam=max([max([svd([d1111 d1112]);0]), max([svd([d1111 ; d1121]);0])]);
gam=gam+1e-5;

                             %  scaling 

q21 = [q21(:,(np2+1):nm1),q21(:,1:np2)];
r21 = inv(r21(1:np2,:))';
c1 = q12*c1;
c2 = r21*c2;
cp = [c1;c2];
b1 = b1*q21;
b2 = b2*r12;
bp = [b1,b2];
d11 = q12*d11*q21;
d12 = q12*d12*r12;
d21 = r21*d21*q21;
d22 = d22;
dp = [d11 d12;d21 d22];
%p = pck(ap,bp,cp,dp);
