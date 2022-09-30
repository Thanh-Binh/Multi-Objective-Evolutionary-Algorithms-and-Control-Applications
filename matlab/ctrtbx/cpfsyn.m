function [acp,bcp,ccp,dcp,gamopt] = cpfsyn(a,b,c,d,design_type) 
% [acp,bcp,ccp,dcp,gamopt] = cpfsyn(a,b,c,d,design_type) 
% This function computes  the H-infinity (sub) optimal 
% controller for the normalised coprime factorisation 
% approach of McFarlane/Gloverused in the  Loop Shaping 
% Design Procedure (LSDP)
%
% Input variables:
%     a b c d        - SHAPED PLANT
%     design_type=1  - Optimal design
%     design_type=2  - Sub-optimal design
%     gam            - desired gamma for suboptimal design
%                      (must be greater than optimal gamma)
%
% Output Variables: 
%    acp,bcp,ccp,dcp - Positive feedback controller 
%    gamopt          - optimal gamma
%

% All Rights Reserved
% Author: To Thanh Binh
% IFAT University of Magdeburg
% Germany

if nargin < 4,
  disp('usage: [acp,bcp,ccp,dcp,gamopt] =  cpfsyn(a,b,c,d,design_type) ')
  error('incorrect number of input arguments')
  return
elseif nargin == 4,
  design_type = 1;
elseif nargin == 5,
  if(design_type~= 1&design_type~= 2),
     error('design_type must be 1 or 2')
     return
  end
end%if
     
[n,m]=size(b);[p,n]=size(c);                                   
S=eye(m)+d'*d;R=eye(p)+d*d';
SI=inv(S);RI=inv(R);

%disp('...SOLVING NORMALIZATION RICCATIS...')
[X1,X2,LAMP,XERR,WELLPOSED,X]=aresolv(a-b*SI*d'*c,c'*RI*c,b*SI*b','eigen');
%[X1,X2,LAMP,XERR,WELLPOSED,X]=aresolv(a-b*SI*d'*c,c'*RI*c,b*SI*b','Schur');
%[X]=are(a-b*SI*d'*c,b*SI*b',c'*RI*c);

if (WELLPOSED=='FALSE'),
 gamopt=0;acp=[];bcp=[];ccp=[];dcp=[];
 return
end

% Check XERR & WELLPOSED;

[Z1,Z2,LAMP,ZERR,WELLPOSED,Z]=aresolv((a-b*SI*d'*c)',b*SI*b',c'*RI*c,'eigen');
%[Z1,Z2,LAMP,ZERR,WELLPOSED,Z]=aresolv((a-b*SI*d'*c)',b*SI*b',c'*RI*c,'Schur');
%[Z]=are((a-b*SI*d'*c)',c'*RI*c,b*SI*b');

if (WELLPOSED=='FALSE'),
 gamopt=0;acp=[];bcp=[];ccp=[];dcp=[];
 return
end

% Calculating optimal gam 
        
gamopt=sqrt(1+max(eig(X*Z)));   %REQUIRED GAM FOR DESIGN

if design_type==1,  % Optimal design
  gam=gamopt;
elseif design_type==2,  %Suboptimal design
  gam=1.1*gamopt;
end%if

F1=-SI*(d'*c+b'*X);
Ac=a+b*F1;
W1=(1-gam*gam)*eye(n)+X*Z;
acp=W1'*Ac+gam*gam*Z*c'*(c+d*F1);
bcp=gam*gam*Z*c';
ccp=b'*X;
dcp=-d';

if design_type==1,
  [acp,bcp,ccp,dcp]=des2ss(acp,bcp,ccp,dcp,W1');   %optimal
elseif design_type==2,
  [acp,bcp,ccp,dcp]=des2ss(acp,bcp,ccp,dcp,W1',0);   %suboptimal
end  
existflag=1;
if ~existflag, 
   gamopt=0;acp=[];bcp=[];ccp=[];dcp=[];
else,
   gamopt=[1;gamopt];
end
