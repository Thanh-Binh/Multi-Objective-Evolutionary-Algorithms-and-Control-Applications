function  [NewX,NewS]=esintxo(OldX,OldS)
% [NewX,NewS]=esintxo(OldX,OldS)
% Evolution Strategy's Integer Multi-Points-Cross-Over
% This function is used to perform a reproduction for
% solving the scheduling problems
% Inputs:
%    OldX, OldS - Parents
% Outputs:
%    NewX, NewS - Children generated after the reproduction 

% Evolution Strategy Toolbox
% Version 3.1
% Dr. To Thanh Binh (University of Magdeburg, Germany)
% All Rights Reserved


nvars=length(OldX(:,1));
indx=randperm(nvars);
indx=indx(1:indx(nvars));
% indx - a set of break points

NewS=OldS; NewX=OldX;
x1=OldX(:,1); x2=OldX(:,2);

NewX(:,1)=dointxo(x1(indx),x2,indx);
NewX(:,2)=dointxo(x2(indx),x1,indx);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y=dointxo(x,y,indx)
% y=dointxo(x,y,indx)
% Do Integer Cross-Over
% Algorithm:
%   A vector Y containts all integers from 1 to N
%   The values of Y in the positions indicated by a vector INDX
%   should be setted by X so that the final vector Y still contains
%   all integers from 1 to N but in other permutation


nx=length(x);
for i=1:nx,
  FindXiInY=find(y==x(i));
  y(FindXiInY)=y(indx(i));
  y(indx(i))=x(i);
end
