% SCRipt for running multiple Genetic Algorithm ToolboX optimizations 1
%
% This script provides an example for defining non-default parameters
% for an optimization. Here is the highest level entry point into the
% GA Toolbox.
%
% Syntax:  scrgtx01
%
% Input parameter:
%    no input parameter
%
% Output parameter:
%    no output parameter
%
% See also: chekgopt, tbxmpga, genalg1

% Author:     Hartmut Pohlheim
% History:    16.02.95     file created


   clear goptions;

   goptions(1) = 2;         % Output
   goptions(5) = 3;         % selection function
   goptions(14) = 100;      % MAXGEN
   goptions(20) = 20;       % NIND
   goptions(21) = 4;        % SUBPOP
   goptions(23) = 1.3;      % SP
   goptions(24) = 2;        % SELSTRUCT

   objfun = 'objfun1';
   bounds = feval(objfun, [], 1);
   VLB = bounds(1,:); VUB = bounds(2,:);
   [xnew, GOPTIONS] = tbxmpga(objfun, goptions, VLB, VUB);


% End of script

