% CROSSOVer Double Point with Reduced Surrogate
%
% This function performs double point 'reduced surrogate' crossover between 
% pairs of individuals and returns the current generation after mating.
%
% Syntax:  NewChrom = xovdprs(OldChrom, XOVR)
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
% See also: recombin, xovdp, xovsprs, xovshrs, xovmp

%  Author:    Hartmut Pohlheim
%  History:   28.03.94     file created

function NewChrom = xovdprs(OldChrom, XOVR);

if nargin < 2, XOVR = NaN; end

% call low level function with appropriate parameters
   NewChrom = xovmp(OldChrom, XOVR, 2, 1);


% End of function
