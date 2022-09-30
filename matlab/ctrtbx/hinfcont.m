function [acl,bcl,ccl1,dcl1,fun,ccl2,dcl2,ak,bk,ck,dk] = hinfcont(ag,bg,cg,dg,aw1,bw1,cw1,dw1,aw2,bw2,cw2,dw2,aw3,bw3,cw3,dw3)
% [acl,bcl,ccl1,dcl1,fun,ccl2,dcl2,ak,bk,ck,dk]=hinfcont(ag,bg,cg,dg,aw1,bw1,cw1,dw1,aw2,bw2,cw2,dw2,aw3,bw3,cw3,dw3)
% 
%    computes the state-space model of the augment plant with weighting
%    strategy as follows:
%
%       W1 :=[aw1 bw1;cw1 dw1] ---- on 'e', the error signal
%       W2 :=[aw2 bw2;cw2 dw2] ---- on 'u', the control signal.
%       W3 :=[aw3 bw3;cw3 dw3] ---- on 'y', the output signal.
%
%    This augmented plant is to be used for Hinf synthese, then W1,W2,W3 are selected
%    so that the augmented plant has d12 of full column rank. An easy way to ensure that
%    it is the case to choose W2=epsilon*I, i.e.
%       aw1=[];bw2=[];cw2=[];dw2=epsilon*eye(m);
%    The augmented system P(s):= (a,b1,b2,c1,c2,d11,d12,d21,d22).
%
%    Using Mu-Toolbox

% All Rights Reserved.
% To Thanh Binh, IFAT University of Magdeburg, Germany

% building the augmented plant
[p,nmeas,ncon]=plantaug(ag,bg,cg,dg,aw1,bw1,cw1,dw1,aw2,bw2,cw2,dw2,aw3,bw3,cw3,dw3);

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

[xinf,yinf,f,h,fail] =bhinfgam(ap,bp,cp,dp,b1,b2,c1,c2,d11,d12,d21,d22,ndata,gamma,2);

if fail == 1,
    fun=0;                      % solutions of Riccati-equations do not exist
    return
end

                               % check the conditions for xinf, yinf

xeig = min(real(eig(xinf)));
yeig = min(real(eig(yinf)));
epp=1e-6;

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

if nargout <5,
  [acl,bcl,ccl1,dcl1] = hinfcfg(ap,b1,b2,c1,c2,d11,d12,d21,d22,ak,bk,ck,dk);
else,
  [acl,bcl,ccl1,dcl1,ccl2,dcl2] = hinfcfg(ap,b1,b2,c1,c2,d11,d12,d21,d22,ak,bk,ck,dk);
end




