% ToolBoX Distributed BINary/integer genetic algorithm
%
% Syntax:  [xnew, GOPTIONS] = tbxdbin(FUN, GOPTIONS, VLB, VUB, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10)
%
% Input parameter:
%    FUN       - Name of m-file containing the objective function or
%                matlab-expression of objective function
%                The function 'FUN' should return the values of the
%                objectives, ObjV = FUN(X).
%    GOPTIONS  - vector of parameters, see chekgopt for details
%    VLB       - vector containing lower bounds of domain of objectives
%    VUB       - vector containing upper bounds of domain of objectives
%    P1-P10    - (optional) parameters, passed through to FUN
%
% Output parameter:
%    xnew      - best objective values of FUN, obtained during all generations.
%    GOPTIONS  - same as input parameter, returns parameter set,
%                see chekgopt for details
%
% See also: genalg1, scrgtx01, tbxdbga, tbxmpga, tbxloga

% Author:     Hartmut Pohlheim
% History:    23.05.95     file created

function [xnew, GOPTIONS] = tbxdbin(FUN, GOPTIONSIN, VLB, VUB, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10);

% Get size of Goptions vector
   SizeGoptions = max(size(chekgopt));

% Check input parameters
   if nargin < 2, GOPTIONSIN = zeros(SizeGoptions,1); end
   if (nargin < 4), VUB = []; if nargin < 3, VLB = []; end, end
   if (isempty(VLB) | isempty(VUB)),    % Get boundaries from objective function (optional)
      bounds = feval(FUN,[],1);
      if isempty(VLB), VLB = bounds(1,:); end
      if isempty(VUB), VUB = bounds(2,:); end
   end

% Get number of variables from boundaries
   NVAR = size(VLB, 2);

% Set function specific parameters
   GOPTIONS_SET = zeros(SizeGoptions,1);
   GOPTIONS_SET(5)  = 3;       % Selection algorithm
   GOPTIONS_SET(6)  = 2;       % Mutation algorithm
   GOPTIONS_SET(7)  = 10;      % Recombination algorithm
   GOPTIONS_SET(14) = 20 * floor(sqrt(NVAR));     % Maximal number of generations
   GOPTIONS_SET(19) = 2;       % integer variable values
   GOPTIONS_SET(20) = 20 + 5 * floor((NVAR-1)/100);  % Number of individuals per subpopulations
   GOPTIONS_SET(21) = max(1, 2 * floor(sqrt(NVAR/20)));  % Number of subpopulations
   GOPTIONS_SET(22) = 0.9;     % Generation gap
   GOPTIONS_SET(27) = 1;       % Migration structure: neighbourhood

% Set GOPTIONS with input parameters
   GOPTIONS = zeros(SizeGoptions,1);
   lengoptin = length(GOPTIONSIN);
   GOPTIONS(1:lengoptin)=GOPTIONSIN(1:lengoptin);

% Add function specific parameter values
   GOPTIONS = GOPTIONS + (GOPTIONS == 0) .* GOPTIONS_SET;

% Set missing parameters with default values
   GOPTIONS = chekgopt(GOPTIONS, NVAR);

% Build string for calling genetic algorithm
   genevalstr = ['genalg1(FUN, GOPTIONS, VLB, VUB'];
   if ~any(FUN < 48)
      for i = 1:nargin-4
         genevalstr = [genevalstr, ',P', int2str(i)];
      end
   end
   genevalstr = [genevalstr, ')'];

% Call Genetic Algorithm function
   [xnew, GOPTIONS] = eval(genevalstr);


% End of function

