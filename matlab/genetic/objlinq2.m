% OBJective function for LINear Quadratic problem 2
%
% This function implements the continuous LINear Quadratic problem.
%
% Syntax:  ObjVal = objlinq2(Chrom, switch, TSTART, TEND)
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
%                if Chrom ~[], method of simulation
%    TSTART    - (optional) start time
%    TEND      - (optional) end time
%
% Output parameters:
%    ObjVal    - Column vector containing the objective values of the
%                individuals in the current population.
%                if called with Chrom == [], then ObjVal contains
%                switch == 1, matrix with the boundaries of the function
%                switch == 2, text for the title of the graphic output
%                switch == 3, value of global minimum
%    t         - time vector of last simulation
%    x         - matrix containing state values of last simulation
%                
% See also: simlinq1, simlinq2, objlinq, objdopi, objharv, objpush

% Author:     Hartmut Pohlheim
% History:    03.03.94     file created 
%             06.04.94     all linq (sim, ode, con) in 1 file
%             17.02.95     direct Dim removed,
%                          additional parameters introduced and
%                          function cleaned


function [ObjVal, t, x] = objlinq2(Chrom, switch, TSTART, TEND);

% initial conditions
   XINIT = [100];

% end conditions
   XEND = [0];

% weights for control and end
   XENDWEIGHT = [20];              % XEND
   XWEIGHT = [2];                  % State vector
   UWEIGHT = [1];                  % Control vector
   
% Compute population parameters
   [Nind, Nvar] = size(Chrom);

% Check size of Chrom and do the appropriate thing
   % if Chrom is [], then
   if Nind == 0
      % Default dimension of objective function
      Dim = 20;
      % return text of title for graphic output
      if switch == 2
         ObjVal = ['Linear-quadratic problem'];
         % if     method == 2, ObjVal = ['Linear-quadratic problem (ode)'];
         % elseif method == 3, ObjVal = ['Linear-quadratic problem (con)'];
         % else                ObjVal = ['Linear-quadratic problem (sim)'];
         % end
      % return value of global minimum
      elseif switch == 3
         ObjVal = 16180.3399;
      % define size of boundary-matrix and values
      else   
         % lower and upper bound, identical for all n variables        
         ObjVal = rep([-600; 0],[1 Dim]);
      end
   % compute values of function
   else
      % Define used method
      if (nargin < 2), method = 1;          % 1 - sim: simulink model
      elseif isempty(switch), method = 1;   % 2 - ode: ordinary differential equations
      else method = ceil(switch); end       % 3 - con: transfer function to state space
      % Set default values, if not defined
      if nargin < 3, TSTART = 0; end
      if nargin < 4, TEND = 1; end
      % Compute stepsize and time vector
      STEPSIMU = min(0.1, abs((TEND - TSTART)/(Nvar - 1)));
      TIMEVEC = linspace(TSTART, TEND, Nvar)';
      % Start computation of objective function
      if method == 3,      % Convert transfer function to state space system
         [NC DC]=cloop(1, [1 0], +1);
         [Ai2 Bi2 Ci2 Di2] = tf2ss(NC, DC);
         t = TIMEVEC;
      end
      ObjVal = zeros(Nind,1);
      for indrun = 1:Nind
         steuerung = [TIMEVEC Chrom(indrun,:)'];
         if method == 2,
            [t x] = linsim('simlinq2', [TSTART TEND], [], [1e-3; STEPSIMU; STEPSIMU], steuerung);
         elseif method == 3,
            [y x] = lsim(Ai2, Bi2, Ci2, Di2, Chrom(indrun,:), TIMEVEC, XINIT);
         else 
            [t x] = linsim('simlinq1', [TSTART TEND], [], [1e-3; STEPSIMU; STEPSIMU], steuerung);            
         end
         % Calculate objective function, endvalues, trapez-integration for control vector
         ObjVal(indrun) = (XENDWEIGHT * ( x(size(x,1),:)^2 )) + ...
                          (UWEIGHT / (Dim-1) * trapz(Chrom(indrun,:).^2)) + ...
                          (XWEIGHT / size(x,1) * sum(x.^2));
      end
   end   


% End of function

