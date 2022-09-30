% SELection in the LOCAL neighbourhood
%
% This function performs SELection in the LOCAL neighbourhood.
%
% Syntax:  NewChrIx = sellocal(FitnV, Nsel, SelOpt)
%
% Input parameters:
%    FitnV     - Column vector containing the fitness values of the
%                individuals in the population.
%    Nsel      - Number of individuals to be selected
%    SelOpt    - (optional) Vector containing selection paremeters
%                SelOpt(1): Structure - number indicating the structure
%                           of the neighbourhood
%                           0: linear, full; 1: linear, half;
%                           2: torus, full star; 3: torus, half star; 
%                           if omitted or NaN, 0 is assumed
%
% Output parameters:
%    NewChrIx  - Column vector containing the indexes of the selected
%                individuals relative to the original population, shuffeld.
%                The new population, ready for mating, can be obtained
%                by calculating OldChrom(NewChrIx,:).
%
% See also: select, selsus, selrws, seltrunc, reinsloc

% Author:     Hartmut Pohlheim
% History:    17.05.94     file created
%             07.09.94     selection structure local implemented
%             10.09.94     vectorization of all loops
%             17.02.95     SelOpt added


function NewChrIx = sellocal(FitnV, Nsel, SelOpt);

% Structure of neighbourhood
   if nargin < 3, SELSTRUCT = 0; end
   if (SELSTRUCT > 3), error('parameter SELSTRUCT is too big'); end

% Random selection/stochastic universal sampling/local selection for odd parents
   SELODD = 2;           % 0: random selection; 1: fitness based (selsus);
                         % 2: uniform local; default: 2
% Random selection/best neighbour for even parents
   SELEVEN = 0;          % 0: random neighbour; 1: best neighbour; default: 1

% Identify the population size (Nind)
   [Nind, ans] = size(FitnV);
   Npar = ceil(Nsel/2);

% Define window/deme size
   if (SELSTRUCT == 0 | SELSTRUCT == 1), 
      Nwin = max(1, floor(Nind^.25));
   else
      Nwin = max(1, floor((Nind^.25)/2));
      Nsq = ceil(sqrt(Nind));
   end

% Random selection or stochastic universal sampling for odd parents
   if SELODD == 0,
   % Select odd parents at random
      Ix1 = ceil(Nind*rand(Npar, 1));
   elseif SELODD == 1,    % selsus
   % Perform stochastic universal sampling for odd parents
      Ix1 = selsus(FitnV, Npar);
   else     % if SELODD == 2,
   % Select odd parents locally
      Ix1 = sort(selsus(ones(size(FitnV)),Npar));
   end
   Ix2 = Ix1(1:floor(Nsel/2));

% Construct matrix according structure and
% Select indices in window around selected parent
   MatInd2 = []; 
   % vector with all necessary indices
   if SELSTRUCT == 0,         % linear, full 
      MatInd2 = rep(Ix2,[1,2*Nwin])+rep([-Nwin:-1,1:Nwin],[size(Ix2,1),1]);
      MatInd2 = MatInd2 + (MatInd2 <= 0)*Nind - (MatInd2 > Nind)*Nind;
   elseif SELSTRUCT == 1,    % linear, half
      MatInd2 = rep(Ix2,[1,Nwin])+rep([1:Nwin],[size(Ix2,1),1]);
      MatInd2 = MatInd2 - (MatInd2 > Nind)*Nind
   elseif SELSTRUCT == 2,    % torus, full star
      Index2 = [-Nsq*Nwin:Nsq:-Nsq, -Nwin:-1, 1:Nwin,Nsq:Nsq:Nsq*Nwin];
      MatInd2 = rep(Ix2,[1,4*Nwin])+rep(Index2,[size(Ix2,1),1]);
      MatInd2 = MatInd2 + (MatInd2 <= 0)*Nind - (MatInd2 > Nind)*Nind;
   else     % if SELSTRUCT == 3,    % torus, half star
      Index2 = [1:Nwin,Nsq:Nsq:Nsq*Nwin];
      MatInd2 = rep(Ix2,[1,2*Nwin])+rep(Index2,[size(Ix2,1),1]);
      MatInd2 = MatInd2 - (MatInd2 > Nind)*Nind;
   end

% Select mating partner from neighbourhood
   NewChrIx = [];
   if SELEVEN == 0,   % random neighbour
      Best2 = ceil(size(MatInd2,2)*rand(size(MatInd2,1),1));
      Best2 = MatInd2((Best2-1)*size(MatInd2,1)+[1:size(MatInd2,1)]');
   else        % if SELEVEN == 1,   % best neighbour
      Temp1 = rep(FitnV,[1,size(MatInd2,2)]);
      [Dummy, Best2] = max(Temp1(MatInd2)');
      Best2 = MatInd2((Best2'-1)*size(MatInd2,1)+[1:size(MatInd2,1)]');
   end

% Add odd and even parent, if Nsel is odd, last odd parent is added
   NewChrIx(1:2:Nsel) = Ix1;
   NewChrIx(2:2:Nsel) = Best2;
   NewChrIx = NewChrIx';
   

% End of function
