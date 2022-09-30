% SIMulation Modell of DOPpelIntegrator, s-function, Vectorized
%
% This function implements the modell of the double integrator.
%
% Syntax:  [sys, x0] = simdopiv(t, x, u, flag)
%
% Input parameters:
%    t         - given time point
%    x         - current state vector
%                1 column for every individual
%    u         - input vector
%                1 column for every individual
%    flag      - flags
%
% Output parameters:
%    sys       - Vector containing the new state derivatives
%                1 column for every individual
%    x0        - initial value            
%
% See also: objdopi, simdopi1, simlinq2

% Author:     Hartmut Pohlheim
% History:    17.05.95     file created

function [sys, x0] = simdopiv(t, x, u, flag);

% Linear Systems Description

   if abs(flag) == 1
   	sys(1,:) = u(1,:);       % Derivatives
   	sys(2,:) = x(1,:);       % Derivatives
   elseif abs(flag) == 0
   	sys=[2,0,0,1,0,0]; x0 = [0; -1];
   end


% End of function
