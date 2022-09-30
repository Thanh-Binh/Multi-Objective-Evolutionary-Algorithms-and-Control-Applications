% OBJective function for ONEmax function 1
%
% This function implements the ONEMAX function 1.
%
% Syntax:  [ObjVal, Nind, Nvar] = objone1(Chrom, switch)
%
% Input parameters:
%    Chrom     - Matrix containing the chromosomes of the current
%                population. Each row corresponds to one individual's
%                string representation.
%                if Chrom == [], then special values will be returned
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
% See also: objfun1

% Author:     Hartmut Pohlheim
% History:    23.05.95     file created (copy of objfun1.m)

function ObjVal = objone1(Chrom, switch);

% Compute population parameters
   [Nind, Nvar] = size(Chrom);

% Check size of Chrom and do the appropriate thing
   % if Chrom is [], then define size of boundary-matrix and values
   if Nind == 0
      % Default dimension of objective function
      Dim = 100;
      % return text of title for graphic output
      if switch == 2
         ObjVal = ['ONEMAX function 1'];
      % return value of global minimum
      elseif switch == 3
         ObjVal = -Dim;
      % define size of boundary-matrix and values
      else   
         % lower and upper bound, identical for all n variables        
         ObjVal = rep([0; 1], [1 Dim]);
      end
   % compute values of function
   else
      % function ONEMAX 1, sum of xi == 1 for i = 1:Nvar (Nvar = 100)
      % n = Nvar, xi in [0, 1] (binary)
      % global minimum at (xi) = (1) ; fmin = Nvar
      ObjVal = -sum((Chrom)')';
   end   


% End of function

