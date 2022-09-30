function [acl,bcl,ccl1,dcl1,ccl2,dcl2] = hinfcfg(a,b1,b2,c1,c2,d11,d12,d21,d22,ak,bk,ck,dk);
% [acl,bcl,ccl1,dcl1,ccl2,dcl2] = hinfcfg(a,b1,b2,c1,c2,d11,d12,d21,d22,ak,bk,ck,dk);
%
% Produces a closed-loop from the plant and controller Tu1y1, Tu1u2
% Plant:
%      dX/dt  = a*X  + b1*u1  + b2*u2
%         y1  = c1*X + d11*u1 + d12*u2
%         y2  = c2*X + d21*u1 + d22*u2
%  Controller:
%       dXk/dt = ak*Xk + ak*y2
%          u2   = ck*Xk + dk*y2
%
%                            Augmented Plant
%                         -------------------                
%  u1 (nu1) -----------> |    a   b1   b2    | -------------> y1 
%                        |    c1  d11  d12   |
%           u2  /------> |    c2  d21  d22   | ------\ y2 
%               |        ---------------------       |          
%               |                                    |
%               |              ---------             |        
%               \-------------|  ak  bk |<-----------/        
%                             |  ck  dk | 
%                              ---------  
%                              Controller


% All Rights Reserved. 24-May-96
% To Thanh Binh University of Magdeburg, Germany

errortxt1=abcdchk(a,[b1,b2],[c1;c2],[d11,d12;d21,d22]);
errortxt2=abcdchk(ak,bk,ck,dk);
if ~isempty(errortxt1)|~isempty(errortxt2),
  evoldlg(str2mat(errortxt1,errortxt2),'Error','');
end

X=inv(eye(size(dk,1))-dk*d22);

acl=[a+b2*X*dk*c2         ,b2*X*ck;...
     bk*c2+bk*d22*X*dk*c2 ,ak+bk*d22*X*ck];
bcl=[b1+b2*X*dk*d21; bk*d21+bk*d22*X*dk*d21];
ccl1=[c1+d12*X*dk*c2, d12*X*ck];
dcl1=d11+d12*X*dk*d21;

if nargout > 4, % for Tu1u2
                % u2 =ccl2*xsys+dcl2*u1   
  ccl2=[X*dk*c2, X*ck];
  dcl2=X*dk*d21;
end



