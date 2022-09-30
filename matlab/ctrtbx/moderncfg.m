function [acl,bcl,ccl1,dcl1,f,ccl2,dcl2]=moderncfg(x,controller_type,a,b,c,d,weight_par);
% [acl,bcl,ccl1,dcl1,f,ccl2,dcl2]=moderncfg(x,controller_type,a,b,c,d,weight_par);
% Main routine for creating the state-space matrice of the 
% closed-loop system using modern controller: LQG-, Hinf-, Mu-Controller
%
% Inputs:
%    [a,b,c,d]     - the state-matrice of the plant 
%    controller_type - one of the following strings 'lqg','hinf'
%    weight_par      - a matrix includes parameters of the weighting matrices 
%                      W1,W2,W3 for H-inf synthese
%
% Outputs: 
%    [acl,bcl,ccl1,dcl1,ccl2,dcl2] - the state-matrice of the closed-loop system 
%    TF(r-->y)=[acl,bcl;ccl1,dcl1] - Transfer function from reference to outputs     
%    TF(r-->u)=[acl,bcl;ccl2,dcl2] - Transfer function from reference to actuator variables
%          used only to calculate the manipulated variables
%    [Ae,Be,Ce,De]   - the state-matrice of the controller
%    f               - the objective (cost) function only for LQG-, H-inf controller


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 
%

if nargin <7, weight_par=[]; end
if nargin <6, 
   error('At least five arguments required!')
end
if ~isstr(controller_type), 
   error('The second variable must be the string as lqg and hinf'); 
end

Ae=0;Be=0;Ce=0;De=0;
f=1; % this means resf is normally equal to 1, 
     % it is only changed for LQG-, h2-, or hinf-controller, when
     % these controller do not exist.

[n,m]=size(b);[p,n]=size(c);

if  strcmp(controller_type,'lqg'),
    
    % x=[qc1,qc2,..,qcr,qf1,qfm,rhoc,rhof]'; 
    % with m,r- number of inputs,outputs respectively
    % controller hat the same dimension as the originale plant        

    ricmethode=2;
    if nargout>5,
       [acl,bcl,ccl1,dcl1,f,ccl2,dcl2]=lqgcfg11(x,a,b,c,d,ricmethode); 
    else,
       [acl,bcl,ccl1,dcl1,f]=lqgcfg11(x,a,b,c,d,ricmethode); 
       ccl2=[];dcl2=[];
    end
    E=[];

elseif strcmp(controller_type,'hinf'),

    ricmethode=2;    
    %[f,sys] = baugm(x,a,b,c,d,weight_par);
    if ~f, return, end
    %[A,B,C,D,f,Ae,Be,Ce,De]= bhinf(sys,r,m,ricmethode);
    E=[];
end
