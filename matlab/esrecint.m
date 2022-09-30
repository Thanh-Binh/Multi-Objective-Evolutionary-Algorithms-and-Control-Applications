function [NewX, NewS] = esrecint(OldX, OldS);
% [NewX, NewS] = esrecint(OldX, OldS);
% Evolution Strategy with RECombination extended INTermediate
%
% This function performs extended intermediate recombination between
% pairs of individuals and returns the new individuals after mating.
%
%
% Inputs:
%     OldX, OldS - variables and strategy parameters of the parents
% Outputs:
%     NewX, NewS - variables and strategy parameters of the offsprings

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



[nvars,nparent] = size(OldX);
% nparent - number of the parents taking part in the crossover

if ~nparent, error('Two parents at least required!') ; end
if nparent ==1, 
   NewX=OldX;NewS=OldS; 
   return
end

% Identify the number of matings
nmating =floor(nparent/2);

odd=1:2:nparent-1;
even=2:2:nparent;

% position of value of offspring compared to parents
Alpha = -0.25 + 1.5 * rand(nvars,nmating);

% recombination
NewX(:,odd)  = OldX(:,odd) + Alpha .* (OldX(:,even) - OldX(:,odd));
NewS(:,odd)  = OldS(:,odd) + Alpha .* (OldS(:,even) - OldS(:,odd));

% the same ones more for second half of offspring
Alpha = -0.25 + 1.5 * rand(nvars,nmating);
NewX(:,even) = OldX(:,odd) + Alpha .* (OldX(:,even) - OldX(:,odd));
NewS(:,even) = OldS(:,odd) + Alpha .* (OldS(:,even) - OldS(:,odd));

NewS=abs(NewS);


