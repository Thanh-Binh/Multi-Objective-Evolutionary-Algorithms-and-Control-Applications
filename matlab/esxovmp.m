function [NewX, NewS] = esxovmp(OldX, OldS);
% [NewX, NewS] = esxovmp(OldX, OldS);
% Evolution Strategy with Crossover of Multi-Parents
% It can perform: single-point- or multi-point- or uniform crossover
%
% Inputs:
%     OldX, OldS - variables and strategy parameters of the parents
% Outputs:
%     NewX, NewS - variables and strategy parameters of the offsprings

% To Thanh Binh, 15-July-96


[nvars,nparent] = size(OldX);
% nparent - number of the parents taking part in the crossover

if ~nparent, error('Two parents at least required!') ; end
if nparent ==1, 
   NewX=OldX;NewS=OldS; 
   return
end

%  Pmask - Probability of creating the mask

Pmask = 0.5; 

if nvars==2,
   Mask=[0;1];

elseif nvars >2,
   duplicate=1;
   while duplicate,
      Mask = rand(nvars,1) < Pmask;
      if any(Mask)&any(~Mask), duplicate=0; end
   end
end

odd=1:2:nparent-1;
even=2:2:nparent;

% Perform crossover
NewX(:,odd) = (OldX(:,odd).* Mask) + (OldX(:,even).*(~Mask));
NewS(:,odd) = (OldS(:,odd).* Mask) + (OldS(:,even).*(~Mask));
NewX(:,even) = (OldX(:,odd).* (~Mask)) + (OldX(:,even).*Mask);
NewS(:,even) = (OldS(:,odd).* (~Mask)) + (OldS(:,even).*Mask);

