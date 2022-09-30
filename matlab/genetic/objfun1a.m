% OBJective function for axis parallel hyper-ellipsoid
%
% This function implements the axis parallel hyper-ellipsoid.
%
% Syntax:  ObjVal = objfun1a(Chrom, switch)
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
% See also: objfun1, objfun1b, objfun2, objfun6, objfun7, objfun8, objfun9, objfun10

% Author:     Hartmut Pohlheim
% History:    07.04.94     file created
%             17.02.95     direct Dim removed and function cleaned

function ObjVal = objfun1a(Chrom, switch);

   
% Compute population parameters
   [Nind, Nvar] = size(Chrom);

% Check size of Chrom and do the appropriate thing
   % if Chrom is [], then define size of boundary-matrix and values
   if Nind == 0
      % Default dimension of objective function
      Dim = 10;
      % return text of title for graphic output
      if switch == 2
         ObjVal = ['Axis Parallel Hyper-Ellipsoid 1a'];
      % return value of global minimum
      elseif switch == 3
         ObjVal = 0;
      % define size of boundary-matrix and values
      else   
         % lower and upper bound, identical for all n variables        
         ObjVal = rep([-512; 512], [1 Dim]);
      end
   % compute values of function
   else
      % function 1a, sum of i * xi^2 for i = 1:Nvar (Nvar = 30)
      % n = Nvar, -512 <= xi <= 512
      % global minimum at (xi) = (0) ; fmin = 0
      nummer = rep(1:Nvar, [Nind 1]);
      ObjVal = sum((nummer .* (Chrom .* Chrom))')';
      % ObjVal = diag((nummer .* (Chrom * Chrom))');  % both lines produce the same
   end   


% End of function

