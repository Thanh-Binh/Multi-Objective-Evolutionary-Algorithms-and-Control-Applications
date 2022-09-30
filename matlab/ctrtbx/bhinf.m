function [acl,bcl,ccl,dcl,fun,ak,bk,ck,dk] = bhinf(p,nmeas,ncon,ricmethd) 
%  [acl,bcl,ccl,dcl,fun,ak,bk,ck,dk] = bhinf(p,nmeas,ncon,ricmethd)
%
%  This function computes the H-infinity (sub) optimal n-state
%  controller, using Glover's and Doyle's 1988 result, for a system P.
%  the system P is partitioned:   
%                                    np  nm1  nm2
%                           p =    | a   b1   b2   | np
%                                  | c1  d11  d12  | np1
%                                  | c2  d21  d22  | np2
% 
%   where b2 has column size of the number of control inputs (NCON)
%   and c2 has row size of the number of measurements (NMEAS) being
%   provided to the controller.
% 
%  It is used also to calculate the objective function of H-infinity
%  and returns the obtained value of the objective function in
%  variable gamma. Here is agmma the upper value of the spectral
%  radius of xinf and yinf.
%   inputs:
%      P        -   interconnection matrix for control design
%      NMEAS    -   # controller inputs (np2)
%      NCON     -   # controller outputs (nm2)
%      RICMETHD -   Riccati solution via
%                     1 - eigenvalue reduction (balance)
%                    -1 - eigenvalue reduction (no balancing)
%                     2 - real schur decomposition  (balance,default)
%                    -2 - real schur decomposition  (no balancing)
%    outputs:
%      K                   -   H-infinity controller
%      acl,bcl,cccl,dcl    -   closed-loop system
%      fun=[~fail,gamma]   -   final gamma value used in control design
%
%   the following assumptions are made:
%    (i)   (a,b2,c2) is stabilizable and detectable
%    (ii)  d12 and d21 have full rank
%     on return, the eigenvalues in egs must all be > 0
%     for the closed-loop system to be stable and to
%     have inf-norm less than GAM.
%
%  Reference Paper:
%       Advanced  control systems design
%       Ching-Fang Lin  Prentice Hall 1994
%     and Mu-Toolbox
%
%  See also:

% All Rights Reserved, 31 Aug.1995
% To Thanh Binh IFAT Uni. Magdeburg Germany


if nargin < 3
   error('usage: [acl,bcl,ccl,dcl,fun,ak,bk,ck,dk] = bhinf(p,nmeas,ncon,ricmethd) ')
elseif nargin <4                                    
   ricmethd = 2;                % setup default case to solve ricatti equations
end
 
                                % save the input (original) system to form the closed-loop system
pnom=p;  
                                % In the next lines (function bhinf_st.m) 
                                % we check the rank conditions
                                %      the 1st if-and-only-if-condition for solution of h-infinity problem
                                %      is used to calculate the value of the objective function (gamma)
                                %      
                                % and scale the original plant p
                                % output variables are the system matrix of the scaled system:
                                %
                                %                                    np  nm1    nm2
                                %                         pnew =   | a   b1     b2     | np
                                %                                  | c1  d11    [0;I]  | np1
                                %                                  | c2  [0,I]  d22    | np2
                                % 
                                % the matrix d22 of the original plant is not changed by scaling
                                % the calculation of the H-infinity controller for pnew runs only
                                % with assumptions: d22 of pnew is zeros-matrix, but d22 is used
                                % to calculate controller for the original plant

[ap,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata,r12,r21,fail,gamma] = bhinf_st(p,nmeas,ncon);
if fail == 1,
    fun=0;                      % rank conditions are violated, x does not exist
    return
end

% calculate the xinf, yinf, f,h 

[xinf,yinf,f,h,fail] =bhinfgam(ap,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata,gam,imethd);
if fail == 1,
    fun=0;                      % solutions of Riccati-equations do not exist
    return
end

                                % check the conditions for xinf, yinf

xeig = min(real(eig(xinf)));
yeig = min(real(eig(yinf)));

if xeig < -epp | xeig == nan | yeig < -epp | yeig == nan,   

   fun = 0;                     % change to a stablility test
   return
end
                                % check conditions for the spectral radius of xinf*yinf (the 3rd condition)

if gamma > sqrt(max(abs(eig(xinf*yinf)))),    
   fun =[1 gamma];              % the 3rd condition is satisfied
else
   fun = 0;
   return,
end
                                % form the h-infinity controller

[ak,bk,ck,dk] = bhinf_c(ap,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata,xinf,yinf,f,h,gamma,r12,r21);

                                % form the closed-loop system: the original augmented plant 
                                % and the h-infinity controller

[ap,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata]= bhinf_sp(pnom,nmeas,ncon);
[acl,bcl,ccl,dcl] = bsyscon(ap,b1,b2,c1,c2,d11,d12,d21,d22,ak,bk,ck,dk);
