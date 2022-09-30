% SCRipt for running binary genetic algorithm toolbox optimizations 1
%
% This script provides an example for defining non-default parameters
% for an optimization. Here is the highest level entry point into the
% GA Toolbox.
%
% Syntax:  scrbin1
%
% Input parameter:
%    no input parameter
%
% Output parameter:
%    no output parameter
%
% See also: chekgopt, tbxdbin, genalg1, objone1

% Author:     Hartmut Pohlheim
% History:    23.05.95     file created


   clear goptions;

   goptions(1) = 2;        % Output
   goptions(14) = 100;      % MAXGEN
   goptions(20) = 50;       % NIND
   goptions(21) = 1;        % SUBPOP
   goptions(23) = 1.3;      % SP

   objfun = 'objone1';
   bounds = feval(objfun, [], 1);
   VLB = bounds(1,:); VUB = bounds(2,:);
   [xnew, GOPTIONS] = tbxdbin(objfun, goptions, VLB, VUB);
   

% End of script

