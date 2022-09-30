% ToolBoX LOcal/diffusion Genetic Algorithm
%
% This function implements the diffusion (local selection and
% reinsertion) genetic algorithm.
%
% Syntax:  [xnew, GOPTIONS] = tbxloga(FUN, GOPTIONS, VLB, VUB, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10)
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
% See also: genalg1, scrgtx01, tbxdbga, tbxdbin, tbxmpga

% Author:     Hartmut Pohlheim
% History:    06.02.95     file created
%             08.02.95     function reworked
%             17.02.95     parameters P1-P10 added
%                          matlab expression in FUN now possible

function [xnew, GOPTIONS] = tbxloga(FUN, GOPTIONSIN, VLB, VUB, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10);

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
   GOPTIONS_SET(5)  = 2;       % Selection algorithm
   GOPTIONS_SET(6)  = 0;       % Mutation algorithm
   GOPTIONS_SET(7)  = 0;       % Recombination algorithm
   GOPTIONS_SET(19) = 0;       % real variable values
   GOPTIONS_SET(22) = 0.9;     % Generation gap
   GOPTIONS_SET(23) = 1.3;     % Selection pressure
   GOPTIONS_SET(24) = 0;       % Local selection structure
   GOPTIONS_SET(26) = 0.2;     % Migration rate
   GOPTIONS_SET(27) = 0;       % Migration structure

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

