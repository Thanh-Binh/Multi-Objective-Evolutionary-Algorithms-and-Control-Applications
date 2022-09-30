% OBJective function for rastrigins FUNction 6
%
% This function implements the RASTRIGIN function 6.
%
% Syntax:  ObjVal = objfun6(Chrom, switch)
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
% See also: objfun1, objfun1a, objfun1b, objfun2, objfun7, objfun8, objfun9, objfun10

% Author:     Hartmut Pohlheim
% History:    26.11.93     file created
%             27.11.93     text of title and switch added
%             30.11.93     show Dim in figure titel
%             16.12.93     switch == 3, return value of global minimum
%             01.03.94     name changed in obj*
%             17.02.95     direct Dim removed and function cleaned

function ObjVal = objfun6(Chrom, switch);

% Compute population parameters
   [Nind, Nvar] = size(Chrom);

% Check size of Chrom and do the appropriate thing
   % if Chrom is [], then define size of boundary-matrix and values
   if Nind == 0
      % Default dimension of objective function
      Dim = 20;
      % return text of title for graphic output
      if switch == 2
         ObjVal = ['RASTRIGINs function 6'];
      % return value of global minimum
      elseif switch == 3
         ObjVal = 0;
      % define size of boundary-matrix and values
      else   
         % lower and upper bound, identical for all n variables        
         ObjVal = rep([-5.12; 5.12], [1 Dim]);
      end
   % compute values of function
   else
      % function 6, Nvar * A + sum of (xi^2 - A * cos(Omega * xi)) for i = 1:Nvar (Nvar = 20)
      % n = Nvar, -5.12 <= xi <= 5.12
      % global minimum at (xi)=(0) ; fmin=0
      A = 10;
      Omega = 2 * pi;
      ObjVal = Nvar * A + sum(((Chrom .* Chrom) - A * cos(Omega * Chrom))')';
   end   


% End of function

