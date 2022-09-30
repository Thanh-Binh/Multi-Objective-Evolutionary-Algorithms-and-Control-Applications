function [NewX, NewS] = eshxo(OldX, OldS);
% [NewX, NewS] = eshxo(OldX, OldS)
% Evolution Strategy with Heuristical CrossOver
%
% This function supports  recombinations between one better (first) 
% and all the rest individuals
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

BestX=OldX(:,1);BestX=BestX(1:nvars,ones(1,nparent-1));
BestS=OldS(:,1);BestS=BestS(1:nvars,ones(1,nparent-1));
Radius=.25;   
% position of value of offspring compared to parents
Alpha = Radius*(-1 + 2 * rand(1,nparent-1));
Alpha = Alpha(ones(nvars,1),1:nparent-1);
% heurical recombination
NewX(:,1)  = BestX+ Alpha .* (BestX - OldX(:,2:nparent));
NewS(:,1)  = BestS+ Alpha .* (BestS - OldS(:,2:nparent));

Alpha = Radius*(-1 + 2 * rand(1,nparent-1));
Alpha = Alpha(ones(nvars,1),1:nparent-1);
% heurical recombination
NewX(:,2)  = BestX+ Alpha .* (BestX - OldX(:,2:nparent));
NewS(:,2)  = BestS+ Alpha .* (BestS - OldS(:,2:nparent));

NewS=abs(NewS);

