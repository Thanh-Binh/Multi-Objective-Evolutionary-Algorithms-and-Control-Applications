% REPlicate a Matrix, utility function
%
% This function replicates a matrix in both dimensions.
% This function is widely used in the GA Toolbox.
%
% Syntax:  MatOut = rep(MatIn, REPN);
%
% Input parameters:
%    MatIn     - Input Matrix (befor replicating)
%    REPN      - Vector of 2 numbers, how often replicate in each dimensiom
%                REPN(1): replicate vertically
%                REPN(2): replicate horizontally
%                MatIn = [1 2 3]
%                REPN = [1 2] => MatOut = [1 2 3 1 2 3]
%                REPN = [2 1] => MatOut = [1 2 3;
%                                          1 2 3]
%                REPN = [3 2] => MatOut = [1 2 3 1 2 3;
%                                          1 2 3 1 2 3;
%                                          1 2 3 1 2 3]
%
% Output parameter:
%    MatOut    - Output Matrix (after replicating)
%
% See also: expand

% Author:   Carlos Fonseca & Hartmut Pohlheim
% History:    14.02.94     file created


function MatOut = rep(MatIn, REPN)

% Get size of input matrix
   [N_D,N_L] = size(MatIn);

% Calculate
   Ind_D = rem(0:REPN(1)*N_D-1,N_D) + 1;
   Ind_L = rem(0:REPN(2)*N_L-1,N_L) + 1;

% Create output matrix
   MatOut = MatIn(Ind_D,Ind_L);


% End of function
