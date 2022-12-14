% CROSSOVer SHuffle
%
% This function performs shuffle crossover between pairs of
% individuals and returns the current generation after mating.
%
% Syntax:  NewChrom = xovsh(OldChrom, XOVR)
%
% Input parameters:
%    OldChrom  - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one individual
%                (in binary form).
%    XOVR      - Probability of recombination ocurring between pairs
%                of individuals.
%
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mating, ready to be mutated and/or evaluated,
%                in the same format as OldChrom.
%
% See also: recombin, xovshrs, xovdp, xovsp, xovmp

%  Author:    Hartmut Pohlheim
%  History:   28.03.94     file created

function NewChrom = xovsh(OldChrom, XOVR);

if nargin < 2, XOVR = NaN; end

% call low level function with appropriate parameters
   NewChrom = xovmp(OldChrom, XOVR, 0, 0);


% End of function
