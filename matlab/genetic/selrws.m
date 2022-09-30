% SELection by Roulette Wheel Selection
%
% This function performs selection with Roulette wheel selection.
%
% Syntax:  NewChrIx = selrws(FitnV, Nsel)
%
% Input parameters:
%    FitnV     - Column vector containing the fitness values of the
%                individuals in the population.
%    Nsel      - Number of individuals to be selected
%
% Output parameters:
%    NewChrIx  - Column vector containing the indexes of the selected
%                individuals relative to the original population, shuffeld.
%                The new population, ready for mating, can be obtained
%                by calculating OldChrom(NewChrIx,:).
%
% This function selects a given number of individuals Nsel from a
% population. FitnV is a column vector containing the fitness
% values of the individuals in the population.
%
% The function returns another column vector containing the
% indexes of the new generation of chromosomes relative to the
% original population matrix, shuffled. The new population, ready
% for mating, can be obtained by calculating OldChrom(NewChrIx, :).
%
% See also: select, selsus, sellocal, seltrunc

% Author: Carlos Fonseca,   Updated: Andrew Chipperfield      Hartmut Pohlheim
% Date: 04/10/93,           Date: 27-Jan-94                   31.05.95


function NewChrIx = selrws(FitnV, Nsel, Dummy);

% Identify the population size (Nind)
   [Nind,ans] = size(FitnV);

% Perform Stochastic Sampling with Replacement
   cumfit  = cumsum(FitnV);
   trials = cumfit(Nind) .* rand(Nsel, 1);
   Mf = cumfit(:, ones(1, Nsel));
   Mt = trials(:, ones(1, Nind))';
   [NewChrIx, ans] = find(Mt < Mf & ...
                          [ zeros(1, Nsel); Mf(1:Nind-1, :) ] <= Mt);


% End of function
