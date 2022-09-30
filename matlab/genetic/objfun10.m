% OBJective function for ackley`s path FUNction 10
%
% This function implements the RASTRIGIN function 6.
% Source: Ackley, D. "A connectionist machine for genetic hillclimbing";
%         International series in engineering and computer science, SECS 28,
%         Boston: Kluwer Academic Publishers, 1989
%      look in ICGA5 page 592
%
% Syntax:  ObjVal = objfun10(Chrom, switch)
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
% See also: objfun1, objfun1a, objfun1b, objfun2, objfun6, objfun7, objfun8, objfun9

% Author:     Hartmut Pohlheim
% History:    06.03.95     file created (copy of objfun6.m)

function ObjVal = objfun10(Chrom, switch);

% Compute population parameters
   [Nind, Nvar] = size(Chrom);

% Check size of Chrom and do the appropriate thing
   % if Chrom is [], then define size of boundary-matrix and values
   if Nind == 0
      % Default dimension of objective function
      Dim = 20;
      % return text of title for graphic output
      if switch == 2
         ObjVal = ['ACKLEYs PATH function 10'];
      % return value of global minimum
      elseif switch == 3
         ObjVal = 0;
      % define size of boundary-matrix and values
      else   
         % lower and upper bound, identical for all n variables        
         ObjVal = rep([-32.768; 32.768], [1 Dim]);
      end
   % compute values of function
   else
      % function 10, -a*exp(-b*sqrt(1/Nvar*sum(xi^2))-exp(1/Nvar*sum(cos(c*xi)))+a+e
      % for i = 1:Nvar (Nvar = 20)
      % n = Nvar, -32.768 <= xi <= 32.768
      % global minimum at (xi)=(0) ; fmin=0
      a = 20; b = 0.2; c = 2 * pi; e = exp(1);
      ObjVal = -a * exp(-b * sqrt(1/Nvar * sum((Chrom .* Chrom)')'));
      ObjVal =  ObjVal - exp(1/Nvar * sum(cos(c * Chrom)')') + a + e;
   end   


% End of function

