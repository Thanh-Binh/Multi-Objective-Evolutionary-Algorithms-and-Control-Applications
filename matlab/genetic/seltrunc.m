% SELection by TRUNCation
%
% This function performs SELection by TRUNCation.
%
% Syntax:  NewChrIx = seltrunc(FitnV, Nsel)
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
% See also: select, selsus, selrws, sellocal

% Author:     Hartmut Pohlheim
% History:    17.05.94     file created


function NewChrIx = seltrunc(FitnV, Nsel, Dummy);

% Uniform at random or fitness based selection from truncated parents
   SELPAR = 1;          % 0: uniform at random, 1: fitness based

% Identify the population size (Nind)
   [Nind, ans] = size(FitnV);

% Trunc - truncation threshold in the range [0, 1],
% computed from selection pressure 1/SP
   Trunc = (sum(FitnV) / Nind) / max(FitnV);
   if (Trunc < 0 | Trunc > 1),
      disp('Trunc in truncation selection outside range, set to 0.5');
      Trunc = 0.5;
   end

% Truncate Trunc% best individuals
   [Dummy, Ix1] = sort(-FitnV);
   Ix1 = Ix1(1:ceil(Nind * Trunc));

% Assign fitness values
   if SELPAR == 0,
   % Selects parents from truncated individuals uniform at random
      FitnV1 = ones(ceil(Nind*Trunc),1);
   else      % if SELPAR == 1,
   % Select parents from truncated individuals fitness based
      FitnV1 = FitnV(Ix1);
   end

% Select Nsel individuals from truncated individuals
   Ix2 = selsus(FitnV1, Nsel);

% Create index
   NewChrIx = Ix1(Ix2);


% End of function
