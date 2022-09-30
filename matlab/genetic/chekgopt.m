% CHEcK parameter structure GOPTions
%
% Syntax:  GOPTIONS = chekgopt(GOPTIONSIN, NVAR)
%
% Input parameter:
%    GOPTIONSIN- Structure of parameters for Genetic Algorithm Toolbox
%    NVAR      - (optional) Number of variables/objectives,
%                used for defining number of generations, individuals and subpopulations
%                if empty or omitted, NVAR = 10 is assumed
%
% Output parameter:
%    GOPTIONS  - same as input, missing values added/defined
%
% See also: genalg1, tbxmpga, tbxdbga, tbxdbin, tbxloga, gatbxini

% Author:     Hartmut Pohlheim
% History:    08.02.95     file created
%             30.05.95     parameters 28-30 added


function GOPTIONS = chekgopt(GOPTIONSIN, NVAR);

% Define size of options vector
   SizeGoptions = 30;

% Check input parameters
   if (nargin < 1), GOPTIONSIN = []; end
   if isempty(GOPTIONSIN), GOPTIONSIN = zeros(SizeGoptions, 1); end
   if (nargin < 2), NVAR = []; end
   if isempty(NVAR), NVAR = 10; end    % NVAR used for setting some default values

% Set default parameter values
   GOPTIONS_DEF = zeros(SizeGoptions, 1);
   GOPTIONS_DEF(1)  = 0;                               % Output
   GOPTIONS_DEF(2)  = 1.0e-4;                          % Termination for x
   GOPTIONS_DEF(3)  = 1.0e-4;                          % Termination for f
   GOPTIONS_DEF(4)  = 1.0e-7;                          % Termination for g
   GOPTIONS_DEF(5)  = 0;                               % Selection algorithm
   GOPTIONS_DEF(6)  = 0;                               % Mutation algorithm
   GOPTIONS_DEF(7)  = 0;                               % Recombination algorithm
   GOPTIONS_DEF(14) = 200 * floor(sqrt(NVAR));         % Maximal number of generations
   GOPTIONS_DEF(19) = 0;                               % Format of variable values
   GOPTIONS_DEF(20) = 20 + 5 * floor(NVAR/50);         % Number of individuals per subpopulations
   GOPTIONS_DEF(21) = max(1, 2 * floor(sqrt(NVAR)));   % Number of subpopulations
   GOPTIONS_DEF(22) = 1.0;                             % Generation gap
   GOPTIONS_DEF(23) = 2.0;                             % Selection pressure
   GOPTIONS_DEF(24) = 0;                               % Selection structure
   GOPTIONS_DEF(26) = 0.2;                             % Migration rate
   GOPTIONS_DEF(27) = 0;                               % Migration structure
   GOPTIONS_DEF(28) = 0;             % save output to file; name in gatbxini.m
   GOPTIONS_DEF(29) = 0;             % use Init function (m-file); name in gatbxini.m
   GOPTIONS_DEF(30) = 0;             % use State plot function (m-file); name in gatbxini.m


% Set GOPTIONS with input parameters
   GOPTIONS = zeros(SizeGoptions, 1);
   lengoptin = length(GOPTIONSIN);
   GOPTIONS(1:lengoptin) = GOPTIONSIN(1:lengoptin);

% Add missing parameter values from default values
   GOPTIONS = GOPTIONS + (GOPTIONS == 0) .* GOPTIONS_DEF;

% Check for consistency of parameters
   [val, pos] = min(GOPTIONS);
   if  val < 0, error(sprintf('GOPTIONS(%.0d) is smaller than zero.', pos)); end
   if GOPTIONS(5) > 3, error('GOPTIONS(5) too big.'); end
   if GOPTIONS(6) > 2, error('GOPTIONS(6) too big.'); end
   if GOPTIONS(19) > 2, error('GOPTIONS(19) too big.'); end
   if GOPTIONS(6) ~= GOPTIONS(19), error('GOPTIONS(6) doesn''t correspond with GOPTIONS(19).'); end
   if GOPTIONS(19) == 0,
      if GOPTIONS(7) > 3, error('GOPTIONS(7) doesn''t correspond with GOPTIONS(19) - too big.'); end
   else
      if GOPTIONS(7) < 10, error('GOPTIONS(7) doesn''t correspond with GOPTIONS(19).'); end
      if GOPTIONS(7) > 15, error('GOPTIONS(7) too big.'); end
   end
   if GOPTIONS(24) > 3, error('GOPTIONS(24) too big.'); end
   if GOPTIONS(26) >= 1.0, error('GOPTIONS(26) too big.'); end
   if GOPTIONS(27) > 2, error('GOPTIONS(27) too big.'); end


% End of function

