function [acl,bcl,ccl,dcl,f,ccl2,dcl2,Ae,Be,Ce,De] = lqgcfg2(x,a,b,c,d,ricmethod)
%  [acl,bcl,ccl,dcl,f,ccl2,dcl2,Ae,Be,Ce,De] = lqgcfg2(x,a,b,c,d,ricmethod)
%
%  Configurate a closed-loop system using LQG-Controller 
%  (Model 3 using Robust Control Toolbox)
%  with the following structure:
%
%                 ue   ----------             u   -------
%  ref ----->(-)----->|controller|-----------*-->| plant |---*------->y
%             |        ----------                 -------    |
%             |                                              |
%             |______________________________________________|
%
%        
%
%  RICMETHOD determines the method  used to solve the Riccati equations.  
%
%  Inputs:
%     a,b,c,d are the matrices of the originale system 
%     
%     x =[qc1,qc2,..,qcr,qf1,...,qfm,rhoc,rhof] - the design parameter
%     m,r -number of plants inputs and outputs
%    
%     RICMETHOD -   Riccati solution via
%                    1 - eigenvalue reduction (balance)
%                   -1 - eigenvalue reduction (no balancing)
%                    2 - real schur decomposition  (balance,default)
%                   -2 - real schur decomposition  (no balancing)
%  Outputs:
%     Ae,Be,Ce,De      -  H2 optimal controller
%     aa,bb,cc,dd      -  closed-loop system with H2 optimal controller
%     f=[resf,fun]; fun - LQG cost (the objective function)
%
%
%  See also: BLQG, RIC_EIG and RIC_SCHR.

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh, University of Magdeburg Germany 


if nargin <5,
  error('usage: [acl,bcl,ccl,dcl,ccl2,dcl2,f,Ae,Be,Ce,De] = lqgcfg2(x,a,b,c,d,ricmethod)')
elseif nargin <6,
  ricmethod = 2;
end

[n,m]=size(b);[r,n]=size(c);
qc=diag(x(1:r));qf=diag(x(r+1:r+m));rhoc=x(r+m+1);rhof=x(r+m+2);

% Configure for using with Robust Control Toolbox
Q = c'*qc*c;
R = rhoc*eye(m);
Xi = b*qf*b';
Th = rhof*eye(r);
W=[Q , zeros(n,m);zeros(m,n), R];
V = [Xi zeros(n,r); zeros(r,n) Th];

% Compute LQG-Controller
[Ae,Be,Ce,De]=lqg(a,b,c,d,W,V);

%  construct the closed-loop system
%
%  d/dt([x;xe]) = acl*[x;xe]+bcl*ref
%      y        = ccl*[x;xe]+dcl*ref

H=inv(eye(r)+d*De);
acl=[a-b*De*H*c, b*Ce - b*De*H*d*Ce; -Be*H*c   Ae-Be*H*d*Ce];
bcl=[b*De*H; Be*H];
ccl=[c-d*De*H*c, d*Ce-d*De*H*d*Ce];
dcl=d*De*H;
if nargout >5,
   ccl2=[-De*H*c  (Ce-De*H*d*Ce)];
   dcl2=De*H;
else,
   ccl2=[];dcl2=[];
end


% calculate the objective function (LQG cost)

%f  = [1,sqrt(abs(trace(X*b*qf*b' + c'*qc*c*Y + 2*X*a*Y)))];

