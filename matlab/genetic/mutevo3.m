% MUTation by EVOlutionary strategies 3, derandomized self adaption
%
% This function takes a matrix OldChrom containing the real
% representation of the individuals in the current population,
% mutates the individuals corresponding to OldMutMat and returns
% the offspring, NewChrom and the new mutation step matrix, NewMutMat.
%
% This function performs derandomized self adaptation (Ostermeier,
% TU Berlin). However, a different calling syntax than other mutation
% functions is needed. Thus, the function is NOT compatible with
% the normal version of the GA Toolbox.
%
% Syntax:  [NewChrom, NewMutMat] = mutevo3(OldChrom, OldMutMat, NUMOFF)
%
% Input parameter:
%    OldChrom  - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one individual.
%    OldMutMat - Matrix containing the mutation variables of the old
%                population. Each line corresponds to one individual
%    NUMOFF    - Number of offspring to be produced per parent
%
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mating, ready to be mutated and/or evaluated,
%                in the same format as OldChrom.
%    NewMutMat - Matrix containing the mutation variables of the new
%                population. Each line corresponds to one individual
%                in NewChrom.
%
% See also: mutevo1, mutevo2, mutate, mutbga, mut

% Author:     Hartmut Pohlheim
% History:    09.05.94     file created


function [NewChrom, NewMutMat] = mutevo3(OldChrom, OldMutMat, NUMOFF);

% Check parameter consistency
   if nargin < 2, error('not enough input parameter'); end
   if nargout < 2, error('not enough output parameter'); end

   if nargin < 3, NUMOFF = 10;
   elseif isnan(NUMOFF), NUMOFF = 10;
   elseif isempty(NUMOFF), NUMOFF = 10; end

% Identify the population size (Nind) and the number of variables (Nvar)
   [Nind,Nvar] = size(OldChrom);
   OldZetMat = OldMutMat(:,Nvar+1:2*Nvar);
   OldMutMat = OldMutMat(:,1:Nvar);

% Self adaption mutation variables
   BETA_ALL = sqrt(1/Nvar);
   BETA_ONE = 1/Nvar;
   BE = 0.35;
   CE = sqrt(1/Nvar);
   ALPHA = 1.4;

% Copy individuals
   IndChrom = rep(OldChrom,[NUMOFF, 1]);
   IndMutMat = rep(OldMutMat,[NUMOFF, 1]);
   IndZetMat = rep(OldZetMat, [NUMOFF, 1]);
   IndAll = Nind*NUMOFF;
   
% Create random values and accumulation of mutations
   IndZetMat = (1 - CE) * IndZetMat + CE * randn(IndAll, Nvar);

% Mutate mutation matrix
   NormZ = zeros(IndAll,1);
   for irun = 1:IndAll,
      NormZ(irun) = norm(IndZetMat(irun,:));
   end
   NormZ = NormZ ./ (sqrt(CE/(2-CE)) * sqrt(Nvar));
   ALL = exp(NormZ - 1 + 1/(5*Nvar)) .^ BETA_ALL;
   ALL = rep(ALL, [1, Nvar]);
   ONE = (abs(IndZetMat) / sqrt(CE/(2-CE)) + BE) .^ BETA_ONE;

% Calculate mutation matrix for storing
   NewMutMat = IndMutMat .* ALL .* ONE;

% Create offspring
   NewChrom = IndChrom + NewMutMat .* IndZetMat;
   NewMutMat = [NewMutMat, IndZetMat];


% End of function
