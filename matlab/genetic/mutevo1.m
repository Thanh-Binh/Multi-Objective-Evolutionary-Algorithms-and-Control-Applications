% MUTation by EVOlutionary strategies 1, derandomized Self Adaption
%
% This function takes a matrix OldChrom containing the real
% representation of the individuals in the current population,
% mutates the individuals corresponding to OldMutMat and returns
% the offspring, NewChrom and the new mutation step matrix, NewMutMat.
%
% This function implements the derandomized self adaption
% mutation algorithm by Ostermeier et. al. (TU Berlin).
%
% Syntax:  [NewChrom, NewMutMat] = mutevo1(OldChrom, OldMutMat, NUMOFF)
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
% See also: mutevo2, mutevo3, mutate, mutbga, mut

% Author:     Hartmut Pohlheim
% History:    03.02.94     file created
%             14.02.94     function cleaned, implementation more exact
%             28.03.94     major cleanup, Changed* and FieldDR removed


function [NewChrom, NewMutMat] = mutevo1(OldChrom, OldMutMat, NUMOFF);

% Identify the population size (Nind) and the number of variables (Nvar)
   [Nind,Nvar] = size(OldChrom);

% Check parameter consistency
   if nargin < 2, error('not enough input parameter'); end
   if nargout < 2, error('not enough output parameter'); end

   if nargin < 3, NUMOFF = 10;
   elseif isnan(NUMOFF), NUMOFF = 10;
   elseif isempty(NUMOFF), NUMOFF = 10; end

% Self adaption mutation variables
   BETA_ALL = sqrt(1/max(Nvar/1,1));
   BETA_ONE = 1/max(Nvar/1,1);
   BE = 0.35;
   ALPHA = 1.4;

% Copy individuals
   IndChrom = rep(OldChrom,[NUMOFF 1]);
   IndMutMat = rep(OldMutMat,[NUMOFF 1]);
   IndAll = Nind*NUMOFF;
   
% Mutate mutation matrix for mutation
   betaallmat = rand(IndAll,1) < 0.5;
   betaallmat = ALPHA * betaallmat + 1/ALPHA * (~betaallmat);
   betaallmat = rep(betaallmat,[1 Nvar]);
   betaonemat = abs(randn(IndAll,Nvar));
   NewMutMat = betaallmat .* betaonemat;

% Compute, if + or - sign 
   MutMx = 1 - 2 *(rand(IndAll,Nvar) <0.5);
   
% Perform mutation 
   NewChrom = IndChrom + MutMx .* NewMutMat .* IndMutMat;
   
% Mutate mutation matrix for storing
   NewMutMat = IndMutMat.*((betaonemat+BE).^BETA_ONE).*(betaallmat.^BETA_ALL);


% End of function
