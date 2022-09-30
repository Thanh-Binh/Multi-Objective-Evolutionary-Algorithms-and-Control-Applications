% OBJective function for griewangk's FUNction
%
% This function implements the GRIEWANGK function 8.
%
% Syntax:  ObjVal = objfun8(Chrom, switch)
%
% Input parameters:
%    Chrom     - Matrix containing the chromosomes of the current
%                population. Each row corresponds to one individual's
%                string representation.
%                if Chrom == [], then speziell values will be returned
%    switch    - if Chrom == [] and
%                switch == 1 (or []) return boundaries
%                switch == 2 return title
%                switch == 3 return value of global minimum
%
% Output parameters:
%    ObjVal    - Column vector containing the objective values of the
%                individuals in the current population.
%                if called with Chrom == [], then ObjVal contains
%                switch == 1, matrix with the boundaries of the function
%                switch == 2, text for the title of the graphic output
%                switch == 3, value of global minimum
%                
% See also: objfun1, objfun1a, objfun1b, objfun2, objfun6, objfun7, objfun9, objfun10

% Author:     Hartmut Pohlheim
% History:    12.12.93     file created (copy of valfun7.m)
%             16.12.93     switch == 3, return value of global minimum
%             27.01.94     20* in formula, correction ??
%             01.03.94     name changed in obj*
%             17.02.95     direct Dim removed and function cleaned


function ObjVal = objfun8(Chrom, switch);

% Compute population parameters
   [Nind, Nvar] = size(Chrom);

% Check size of Chrom and do the appropriate thing
   % if Chrom is [], then define size of boundary-matrix and values
   if Nind == 0
      % Default dimension of objective function
      Dim = 10;
      % return text of title for graphic output
      if switch == 2
         ObjVal = ['GRIEWANGKs function 8'];
      % return value of global minimum
      elseif switch == 3
         ObjVal = 0;
      % define size of boundary-matrix and values
      else   
         % lower and upper bound, identical for all n variables        
         ObjVal = rep([-600; 600], [1 Dim]);
      end
   % compute values of function
   else
      % function 8, sum(xi^2/4000) - 20 * prod(cos(xi/sqrt(i))) + 1 for i = 1:Nvar (Nvar = 10)
      % n = Nvar, -600 <= xi <= 600
      % global minimum at (xi) = (0) ; fmin = 0
      nummer = rep(1:Nvar, [Nind 1]);
      ObjVal = sum(((Chrom.^2) / 4000)')' - prod(cos(Chrom ./ sqrt(nummer))')' + 1;
   end   


% End of function

