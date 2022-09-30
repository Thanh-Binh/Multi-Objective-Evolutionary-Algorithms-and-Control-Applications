% OBJective function for schwefel's FUNction
%
% This function implements the SCHWEFEL function 7.
%
% Syntax:  ObjVal = objfun7(Chrom, switch)
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
% See also: objfun1, objfun1a, objfun1b, objfun2, objfun6, objfun8, objfun9, objfun10

% Author:     Hartmut Pohlheim
% History:    27.11.93     file created
%             30.11.93     show Dim in figure titel
%             01.03.94     name changed in obj*
%             17.02.95     direct Dim removed and function cleaned


function ObjVal = objfun7(Chrom, switch);

% Compute population parameters
   [Nind, Nvar] = size(Chrom);

% Check size of Chrom and do the appropriate thing
   % if Chrom is [], then define size of boundary-matrix and values
   if Nind == 0
      % Default dimension of objective function
      Dim = 10;
      % return text of title for graphic output
      if switch == 2
         ObjVal = ['SCHWEFELs function 7'];
      % return value of global minimum
      elseif switch == 3
         xmin = 420.9687;
         ObjVal = Dim * (-xmin * sin(sqrt(abs(xmin))));
      % define size of boundary-matrix and values
      else   
         % lower and upper bound, identical for all n variables        
         ObjVal = rep([-500; 500], [1 Dim]);
      end
   % compute values of function
   else
      % function 7, sum of -xi * sin(sqrt(abs(xi))) for i = 1:Nvar (Nvar = 10)
      % n = Nvar, -500 <= xi <= 500
      % global minimum at (xi) = (420.9687) ; fmin = ?
      ObjVal = sum((-Chrom .* sin(sqrt(abs(Chrom))))')';
   end   


% End of function

