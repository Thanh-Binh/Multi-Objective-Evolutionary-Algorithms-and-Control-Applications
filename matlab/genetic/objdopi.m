% OBJective function for DOuble Integrator
%
% This function implements the Double Integrator.
%
% Syntax:  ObjVal = objdopi(Chrom, switch)
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
% See also: simdopiv, simdopi1, objharv, objlinq, objpush

% Author:     Hartmut Pohlheim
% History:    17.12.93     file created (copy of valfun7.m)
%             19.12.93     Dim reintroduced
%                          Dim and STEPSIMU independend from each other,
%                          rk23 can compute control between times
%             01.03.94     name changed in obj*
%             05.04.94     trapz used
%             17.02.95     direct Dim removed,
%                          additional parameters introduced and
%                          function cleaned
%             17.05.95     vectorized version (method == 12) added


function [ObjVal, t, x] = objdopi(Chrom, switch, TSTART, TEND);

% initial conditions
   XINIT = [ 0; -1];

% end conditions
   XEND = [ 0; 0];

% weights for control and end conditions
   XENDWEIGHT = 12 * [1; 1];      % XEND(1); XEND(2)
   UWEIGHT = [0.5];               % Control vector
   
% Compute population parameters
   [Nind, Nvar] = size(Chrom);

% Check size of Chrom and do the appropriate thing
   % if Chrom is [], then
   if Nind == 0
      % Default dimension of objective function
      Dim = 20;
      % return text of title for graphic output
      if switch == 2
         ObjVal = ['Double Integrator'];
         % if     method == 2, ObjVal = ['Double Integrator (ode)'];
         % elseif method == 3, ObjVal = ['Double Integrator (con)'];
         % elseif method ==12, ObjVal = ['Double Integrator (odv)'];
         % else                ObjVal = ['Double Integrator (sim)'];
         % end
      % return value of global minimum
      elseif switch == 3
         ObjVal = 2; % UWEIGHT * 3 * (TEND - TSTART);
      % define size of boundary-matrix and values
      else   
         % lower and upper bound, identical for all n variables        
         ObjVal = rep([-15; 15], [1 Dim]);
      end
   % compute values of function
   else
      % Define used method
      if nargin < 2, method = 1;               % 1 - sim: simulink model
      elseif isempty(switch), method = 1;      % 2 - ode: ordinary differential equations
      else method = switch;                    % 3 - con: transfer function to state space
      end                                      % 12- odv: ordinary differential equations vectorized         
       % Set default values, if not defined
      if nargin < 3, TSTART = 0; end
      if nargin < 4, TEND = 1; end
      % Compute stepsize and time vector
      STEPSIMU = min(0.1, abs((TEND - TSTART)/(Nvar - 1)));
      TIMEVEC = linspace(TSTART, TEND, Nvar)';
      % Start computation of objective function
      if method == 3,      % Convert transfer function to state space system
         [Ai2 Bi2 Ci2 Di2] = tf2ss(1, [1 0 0]);
         t = TIMEVEC;
      end
      ObjVal = zeros(Nind,1);
      if method == 12,
         NCONTR = 1;
         XINIT = rep(XINIT', [Nind, 1]);
         [t, x] = intrk4('simdopiv', [TSTART, TEND], XINIT, ...
                          [1e-3, STEPSIMU, STEPSIMU, NCONTR], Chrom);
         poses = rep(size(t, 1), [Nind, 1]); TimeSimall = expand(t, [Nind, 1]);
         % [t, x(1:Nind:Nind*(size(t, 1)-1)+1,:)]

         ObjVal = (UWEIGHT / (Nvar - 1) * trapz((Chrom').^2)');
         ObjVal = ObjVal + sum(rep(XENDWEIGHT, [1, Nind]) .* ...
                               abs( x(size(x, 1)-Nind+1:size(x, 1),:)' - rep(XEND, [1, Nind])))';
      else
         for indrun = 1:Nind
            steuerung = [TIMEVEC [Chrom(indrun,:)]'];
            if method == 2,
               [t x] = rk23('simdopiv', [TSTART TEND], XINIT, ...
                            [1e-3; STEPSIMU; STEPSIMU], steuerung);
            elseif method == 3,
               [y x] = lsim(Ai2, Bi2, Ci2, Di2, Chrom(indrun,:), TIMEVEC, XINIT);
            else 
               [t x] = rk23('simdopi1', [TSTART TEND], [], ...
                            [1e-3; STEPSIMU; STEPSIMU], steuerung);
            end
            % Calculate objective function, endvalues, trapez-integration for control vector
            ObjVal(indrun) = sum(XENDWEIGHT .* abs( x(size(x, 1),:)' - XEND )) + ...
                             (UWEIGHT / (Nvar - 1) * trapz(Chrom(indrun,:).^2));
         end
      end
   end   


% End of function

