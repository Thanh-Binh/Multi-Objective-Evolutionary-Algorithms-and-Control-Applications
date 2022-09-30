% OBJective function for discrete LINear Quadratic problem
%
% This function implements the discret LINEAR-QUADRATIC PROBLEM.
%
% Syntax:  ObjVal = objlinq(Chrom, switch)
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
%                if Chrom ~[], parameter set
%
% Output parameters:
%    ObjVal    - Column vector containing the objective values of the
%                individuals in the current population.
%                if called with Chrom == [], then ObjVal contains
%                switch == 1, matrix with the boundaries of the function
%                switch == 2, text for the title of the graphic output
%                switch == 3, value of global minimum
%                
% See also: objlinq2, objdopi, objharv, objpush

% Author:     Hartmut Pohlheim
% History:    18.02.94     file created (copy of valfun7.m)
%             01.03.94     name changed in obj*
%             17.02.95     direct Dim removed,
%                          additional parameter introduced and
%                          function cleaned


function ObjVal = objlinq(Chrom, switch);

% Compute population parameters
   [Nind, Nvar] = size(Chrom);

% Check size of Chrom and do the appropriate thing
   % if Chrom is [], then define size of boundary-matrix and values
   if Nind == 0
      % Default dimension of objective function
      Dim = 45;
      % return text of title for graphic output
      if switch == 2
         ObjVal = ['Linear-quadratic problem (dis)'];
      % return value of global minimum
      elseif switch == 3
         ObjVal = 0;   % GlobalMinimum;
      % define size of boundary-matrix and values
      else   
         % lower and upper bound, identical for all n variables        
         ObjVal1 = [-100 -70 -50; 20 20 20];
         ObjVal = [ObjVal1 rep([-30; 20],[1 Dim-3])];
      end
   % if Dim variables, compute values of function
   else
      % Define used parameter set
      if (nargin < 2), var = 1;
      elseif isempty(switch), var = 1;
      else var = ceil(switch); end
      if (var < 1 | var > 10), error('Parameter var is wrong'); end   % 1 - 10 possible

      % values from MICHALEWICZ
      x0 = 100;              % start of X
      Para = [   1    1    1    1    1    16180.3399;
                10    1    1    1    1   109160.7978;
              1000    1    1    1    1 10009990.0200;
                 1   10    1    1    1    37015.6212;
                 1 1000    1    1    1   287569.3725;
                 1    1    0    1    1    16180.3399;
                 1    1 1000    1    1    16180.3399;
                 1    1    1 0.01    1    10000.5000;
                 1    1    1    1 0.01   431004.0987;
                 1    1    1    1  100    10000.9999];
      s = Para(var, 1); r = Para(var, 2); q = Para(var, 3);
      a = Para(var, 4); b = Para(var, 5);
      GlobalMinimum = Para(var, 6);     % correct for Nvar == 45

      % Start computation of objective function
      ObjVal = zeros(Nind, 1);
      X = zeros(Nind, Nvar+1);
      X(:,1) = rep(x0, [Nind 1]);
      for irun = 1:Nvar,
         X(:, irun+1) = a * X(:, irun) + b * Chrom(:, irun);
      end
      ObjVal = q * X(:, Nvar+1).^2 + sum((s * X(:, 1:Nvar).^2 + r * Chrom.^2)')';
   end   


% End of function

