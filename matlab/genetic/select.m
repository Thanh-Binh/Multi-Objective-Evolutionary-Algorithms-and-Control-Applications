% high level SELECTion function
%
% This function is the high level universal selection function. The
% function handles multiple populations and calls the low level
% selection function for the actual selection process.
%
% Syntax:  [SelCh, SelIx] = select(SEL_F, Chrom, FitnV, GGAP, SUBPOP, SelOpt)
%
% Input parameters:
%    SEL_F     - Name of the selection function
%    Chrom     - Matrix containing the individuals (parents) of the current
%                population. Each row corresponds to one individual.
%    FitnV     - Column vector containing the fitness values of the
%                individuals in the population.
%    GGAP      - (optional) Rate of individuals to be selected
%                if omitted 1.0 is assumed
%    SUBPOP    - (optional) Number of subpopulations
%                if omitted 1 subpopulation is assumed
%    SelOpt    - (optional) Vector containing selection paremeters
%                SelOpt(1): Structure - number indicating the structure
%                           of the neighbourhood for local selection
%                           0: linear, full; 1: linear, half;
%                           2: torus, full star; 3: torus, half star; 
%                           if omitted or NaN, 0 is assumed
%
% Output parameters:
%    SelCh     - Matrix containing the selected individuals.
%    SelIx     - (optional) Column vector containing the indices
%                of the selected individuals.
%
% See also: selrws, selsus, sellocal, seltrunc, reins, reinsloc, migrate, mutate, recombin

% Author:     Hartmut Pohlheim
% History:    10.03.94     file created
%             09.09.94     SelIx as output parameter
%             17.02.95     SelOpt added

function [SelCh, SelIx] = select(SEL_F, Chrom, FitnV, GGAP, SUBPOP, SelOpt);

% Check parameter consistency
   if nargin < 3, error('Not enough input parameter'); end

   % Identify the population size (Nind)
   [NindCh,Nvar] = size(Chrom);
   [NindF,VarF] = size(FitnV);
   if NindCh ~= NindF, error('Chrom and FitnV disagree'); end
   if VarF ~= 1, error('FitnV must be a column vector'); end
  
   if nargin < 5, SUBPOP = 1; end
   if nargin > 4,
      if isempty(SUBPOP), SUBPOP = 1;
      elseif isnan(SUBPOP), SUBPOP = 1;
      elseif length(SUBPOP) ~= 1, error('SUBPOP must be a scalar'); end
   end

   if (NindCh/SUBPOP) ~= fix(NindCh/SUBPOP), error('Chrom and SUBPOP disagree'); end
   Nind = NindCh/SUBPOP;  % Compute number of individuals per subpopulation

   if nargin < 4, GGAP = 1; end
   if nargin > 3,
      if isempty(GGAP), GGAP = 1;
      elseif isnan(GGAP), GGAP = 1;
      elseif length(GGAP) ~= 1, error('GGAP must be a scalar');
      elseif (GGAP < 0), error('GGAP must be a scalar bigger than 0'); end
   end

% Build string of selection function
   selstr = [SEL_F '(FitnVSub, NSel'];
   if nargin > 5, selstr = [selstr ', SelOpt']; end
   selstr = [selstr ')'];
   
% Compute number of new individuals (to Select)
   NSel = max(floor(Nind * GGAP + .5), 2);

% Select individuals from population
   SelCh = []; SelIx = [];
   for irun = 1:SUBPOP,
      FitnVSub = FitnV((irun - 1) * Nind + 1:irun * Nind);
      ChrIx = eval(selstr); ChrIx = ChrIx + (irun-1) * Nind;
      % ChrIx = feval(SEL_F, FitnVSub, NSel) + (irun - 1) * Nind;
      SelCh = [SelCh; Chrom(ChrIx,:)];
      SelIx = [SelIx; ChrIx];
   end
 

% End of function
