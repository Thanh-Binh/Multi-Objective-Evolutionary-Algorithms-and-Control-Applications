% OBJective function for rosenbrock's FUNction
%
% This function implements the ROSENBROCK valley (DE JONG's Function 2).
%
% Syntax:  ObjVal = objfun2(Chrom, switch)
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
% See also: objfun1, objfun1a, objfun1b, objfun6, objfun7, objfun8, objfun9, objfun10

% Author:     Hartmut Pohlheim
% History:    26.01.94     file created
%             01.03.94     name changed in obj*
%             17.02.95     direct Dim removed and function cleaned


function ObjVal = objfun2(Chrom, switch);

% Compute population parameters
   [Nind, Nvar] = size(Chrom);

% Check size of Chrom and do the appropriate thing
   % if Chrom is [], then define size of boundary-matrix and values
   if Nind == 0
      % Default dimension of objective function
      Dim = 10;
      % return text of title for graphic output
      if switch == 2
         ObjVal = ['ROSENBROCKs function 2'];
      % return value of global minimum
      elseif switch == 3
         ObjVal = 0;
      % define size of boundary-matrix and values
      else   
         % lower and upper bound, identical for all n variables        
         ObjVal = rep([-2; 2], [1 Dim]);
      end
   % compute values of function
   else
      % function 2, sum of 100 * (x(i+1) -xi^2)^2+(1-xi)^2 for i = 1:Nvar (Nvar = 10)
      % n = Nvar, -10 <= xi <= 10
      % global minimum at (xi) = (1) ; fmin = 0
      Mat1 = Chrom(:,1:Nvar-1);
      Mat2 = Chrom(:,2:Nvar);
      if Nvar == 2
         ObjVal = 100*(Mat2-Mat1.^2).^2+(1-Mat1).^2;
      else
         ObjVal = sum((100*(Mat2-Mat1.^2).^2+(1-Mat1).^2)')';
      end   
   end   


% End of function

