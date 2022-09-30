% Demo of GA toolbox, initialization of all parameters
% 
% This script sets all parameter to default values. It is
% used for the graphical interface of the GA Toolbox (dgagraf).
%
% Syntax:  dganew
%
% See also: dgagraf, dgampga, dgamesh

% Author:     Hartmut Pohlheim
% History:    09.04.94     file created


if ~exist('CODEREAL'),
   CODEREAL = 0;     % Representation of variables; 0: real ; 1: binary
end
GGAP = .9;           % Generation gap, how many new individuals are created
INSR = 1.0;          % Insertion rate, how many of the offspring are inserted
if CODEREAL,
   XOVR =  0.7;      % Crossover rate
   MUTR = 0.7;       % Mutation rate; only a factor;
else
   XOVR =  1;        % Crossover rate
   MUTR = 1;         % Mutation rate; only a factor;
end
RANKMETH = 0;        % Ranking method; 0: linear ; 1: non-linear
SP = 1.3;            % Selective Pressure
MUTSHRINK = 1;       % Shrinking of mutation range
MIGR = 0.15;         % Migration rate between subpopulations
MIGGEN = 20;         % Number of generations between migration (isolation time)
MIGFIT =  1;         % Selection method for migration (0: uniform, 1: fitness)
MIGTOPO = 2;         % Topology of  migration (0: unrestricted,
                     %  1: neighbourhood, 2: ring)
PLOTTIME = 10;        % Number of generations between ploting results

TERMEXACT = 1e-6;    % Value for termination if minimum reached

SEL_F = 'sellocal';       % Name of selection function

if CODEREAL,
   XOV_F = 'xovsh';  % Name of recombination function for individuals
   MUT_F = 'mutbint';    % Name of mutation function
else
   XOV_F = 'recdis'; % Name of recombination function for individuals
   MUT_F = 'mutbga'; % Name of mutation function
end

if ~exist('OBJ_F'),
   OBJ_F = 'objfun6';  % Name of function for objective values
end

% Get boundaries of objective function
   FieldDR = feval(OBJ_F,[],1);

% compute SUBPOP, NIND depending on number of variables (defined in objective function)
   NVAR = size(FieldDR,2);                     % Get number of variables from objective function
   SUBPOP = 2 * floor(sqrt(NVAR));             % Number of subpopulations
   NIND = 20 + 5 * floor(NVAR/50);             % Number of individuals per subpopulations
   MAXGEN = 200 * floor(sqrt(NVAR));           % Maximal number of generations
   MUTR = MUTR / NVAR;                         % Mutation rate depending on NVAR


% End of script
