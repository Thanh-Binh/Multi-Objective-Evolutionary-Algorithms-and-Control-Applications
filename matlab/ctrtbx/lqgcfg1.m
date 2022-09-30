function [acl,bcl,ccl,dcl,f,ccl2,dcl2,Ae,Be,Ce,De] = lqgcfg1(x,a,b,c,d,ricmethod)
%  [acl,bcl,ccl,dcl,f,ccl2,dcl2,Ae,Be,Ce,De] = lqgcfg1(x,a,b,c,d,ricmethod)
%
%  Configurate a closed-loop system using LQG-Controller (Model 2)
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
  error('usage: [acl,bcl,ccl,dcl,ccl2,dcl2,f,Ae,Be,Ce,De] = lqgcfg1(x,a,b,c,d,ricmethod)')
elseif nargin <6,
  ricmethod = 2;
end

[n,m]=size(b);[r,n]=size(c);
if any(x(1:r+m) < 0)| any(x(r+m+1:r+m+2) <=0),
   acl=[];bcl=[];ccl=[];dcl=[];ccl2=[];dcl2=[];
   Ae=[];Be=[];Ce=[];De=[];
   f=0;
   return;
end

qc=diag(x(1:r));qf=diag(x(r+1:r+m));rhoc=x(r+m+1);rhof=x(r+m+2);

if abs(ricmethod) == 1 | abs(ricmethod) == 2,
    hamx = [a, -b*b'/rhoc; -c'*qc*c, -a'];
    hamy = [a', -c'*c/rhof; -b*qf*b', -a];
    if ricmethod == 1,

      % Solve the Riccati equation using eigenvalue decomposition
      % - Balance Hamiltonian

      [X1,X2,failx] = ric_eig(hamx,1e-13);
      if (failx ~= 0), 
         acl=[];bcl=[];ccl=[];dcl=[];ccl2=[];dcl2=[];Ae=[];Be=[];Ce=[];De=[];
         f=0;return,
      end                           % Decomposition failed
      [Y1,Y2,faily] = ric_eig(hamy,1e-13);

    elseif ricmethod == -1,

      % Solve the Riccati equation using eigenvalue decomposition
      % - No Balancing of Hamiltonian Matrix

      [X1,X2,failx] = ric_eig(hamx,1e-13,1);
      if (failx ~= 0),       
         acl=[];bcl=[];ccl=[];dcl=[];ccl2=[];dcl2=[];Ae=[];Be=[];Ce=[];De=[];
         f=0;return,
      end                           % Decomposition failed
      [Y1,Y2,faily] = ric_eig(hamy,1e-13,1);

    elseif ricmethod == 2,

      % Solve the Riccati equation using real schur decomposition
      % - Balance the Hamiltonian Matrix

      [X1,X2,failx] = ric_schr(hamx,1e-13);
      if (failx ~= 0),
         acl=[];bcl=[];ccl=[];dcl=[];ccl2=[];dcl2=[];Ae=[];Be=[];Ce=[];De=[];
         f=0;return,
      end                           % Decomposition failed
      [Y1,Y2,faily] = ric_schr(hamy,1e-13);

    elseif ricmethod == -2,

      % Solve the Riccati equation using real schur decomposition
      % - No Balancing of Hamiltonian Matrix

      [X1,X2,failx] = ric_schr(hamx,1e-13,1);
      if (failx ~= 0), 
         acl=[];bcl=[];ccl=[];dcl=[];ccl2=[];dcl2=[];Ae=[];Be=[];Ce=[];De=[];
         f=0;return,
      end                           % Decomposition failed
      [Y1,Y2,faily] = ric_schr(hamy,1e-13,1);

    end
    if (faily ~= 0), 
       acl=[];bcl=[];ccl=[];dcl=[];ccl2=[];dcl2=[];Ae=[];Be=[];Ce=[];De=[];
       f=0; return,
    end                             % Decomposition failed
    X = real(X2/X1); Y = real(Y2/Y1);
else
    error('invalid Riccati method')
    acl=[];bcl=[];ccl=[];dcl=[];ccl2=[];dcl2=[];Ae=[];Be=[];Ce=[];De=[];
    f=0;
    return
end


% This section of the code can be used to generate all controllers
%
% d/dt(xe) = Ae*xe +Be*ue
%   u      = Ce*xe +zeros(m,r)*ue
%
%  Be=H

 F=b'*X/rhoc; H=Y*c'/rhof; 
 Ae = a - b*F - H*c;
 Be = H;
 Ce = F;
 De = zeros(m,r);

%  construct the closed-loop system
%
%  d/dt([x;xe]) = acl*[x;xe]+bcl*ref
%      y        = ccl*[x;xe]+dcl*ref

acl = [a, b*F; -H*c, Ae];
bcl = [zeros(n,r);H];
ccl = [c, zeros(r,n)];
dcl = zeros(r,m);

% u =Ce*xe+zeros(m,r)*ue
% u =[zeros(m,n) Ce]*[x;xe]+zeros(m,r)*ref
if nargout >5,
   ccl2=[zeros(m,n) Ce];dcl2=zeros(m,r);
else,
   ccl2=[];dcl2=[];
end

% calculate the objective function (LQG cost)

f  = [1,sqrt(abs(trace(X*b*qf*b' + c'*qc*c*Y + 2*X*a*Y)))];

