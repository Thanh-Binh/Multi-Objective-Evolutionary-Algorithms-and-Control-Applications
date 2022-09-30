function [NewX, NewS] = esreclin(OldX, OldS);
% [NewX, NewS] = esreclin(OldX, OldS)
% Evolution Strategy with RECombination extended LINe
%
% This function performs extended line recombination between
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


Interval=[-0.25,1.25];
%Interval=[0,1];
IntervalDiff=Interval(2)-Interval(1);

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
Alpha = Interval(1) + IntervalDiff * rand(1,nmating);
Alpha = Alpha(ones(nvars,1),1:nmating);
% line-recombination
NewX(:,odd)  = OldX(:,odd) + Alpha .* (OldX(:,even) - OldX(:,odd));
NewS(:,odd)  = OldS(:,odd) + Alpha .* (OldS(:,even) - OldS(:,odd));

% the same ones more for second half of offspring
Alpha = Interval(1) + IntervalDiff * rand(1,nmating);
Alpha = Alpha(ones(nvars,1),1:nmating);
% line-recombination
NewX(:,even) = OldX(:,odd) + Alpha .* (OldX(:,even) - OldX(:,odd));
NewS(:,even) = OldS(:,odd) + Alpha .* (OldS(:,even) - OldS(:,odd));

NewS=abs(NewS);
