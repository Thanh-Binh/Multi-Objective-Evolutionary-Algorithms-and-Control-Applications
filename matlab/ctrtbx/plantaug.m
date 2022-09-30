function [A,B1,B2,C1,C2,D11,D12,D21,D22] = plantaug(ag,bg,cg,dg,aw1,bw1,cw1,dw1,aw2,bw2,cw2,dw2,aw3,bw3,cw3,dw3)
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
%
%                                                                 ----
%                      /---------------------------------------->| W1 |---------> y1a
%                      |                                          ---- 
%                      |                                          ----
%                      |               /------------------------>| W2 |---------> y2a
%                      |               |                          ----
%                      |               |      -------             ----
%  u1 -------->(-)-----*  e        u   *---->|   G   |------*--->| W3 |---------> y3a
%               |      |               |      -------       |     ----
%               \-------------------------------------------/  ysys
%                      |               |
%                      \------------------------------------------------------\ y
%                                      |                                      | 
%     u /------------------------------/                                      |
%       |                                                                     |
%       |                                    ---                              |
%       \-----------------------------------| F |<----------------------------/
%                                            ---
%

% All Rights Reserved.
% To Thanh Binh IFAT Uni. Magdeburg Germany 8 .8 .95


% evaluate the dimensions of the plant, W1,W2,W3
[n,m]=size(bg);
[nw1,mw1]=size(bw1);rw1=size(dw1,1);
[nw2,mw2]=size(bw2);rw2=size(dw2,1);
[nw3,mw3]=size(bw3);rw3=size(dw3,1);

% ----- A matrix:
%
A = [ag zeros(n,nw1+nw2+nw3);-bw1*cg aw1 zeros(nw1,nw2+nw3);...
     zeros(nw2,n+nw1) aw2 zeros(nw2,nw3);...
     bw3*cg zeros(nw3,nw1+nw2) aw3];
%
% ----- B matrix:
%
B1 = [zeros(n,mw1);bw1;zeros(nw2+nw3,mw1)];
B2 = [bg;-bw1*dg;bw2;bw3*dg];
%
% ----- C matrix:
%
C1 = [-dw1*cg cw1 zeros(rw1,nw2+nw3);zeros(rw2,n+nw1) cw2 zeros(rw2,nw3);...
      dw3*cg zeros(rw3,nw1+nw2) cw3];
C2 = [-cg zeros(mw1,nw1+nw2+nw3)]; 
% no. of plant outputs is equal the no. of W1-inputs, i.e. r=mw1
%
% ----- D matrix:
%
D11 = [dw1;zeros(rw2+rw3,mw1)];
D12 = [-dw1*dg;dw2;dw3*dg];
D21 = eye(mw1);
D22 = -dg;
%
if nargout==3,
   [nmeas,ncon]=size(dg);
   A=pck(A,[B1,B2],[C1;C2],[D11,D12;D21,D22]);
   B1=nmeas;B2=ncon;
end   
