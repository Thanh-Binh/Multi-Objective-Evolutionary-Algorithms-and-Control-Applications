% CROSSOVer Multi-Point, low level function
%
% This function takes a matrix OldChrom containing the binary
% representation of the individuals in the current population,
% applies crossover to consecutive pairs of individuals with
% probability Px and returns the resulting population.
%
% Npt indicates how many crossover points to use (1 or 2, zero
% indicates shuffle crossover).
% Rs indicates whether or not to force the production of
% offspring different from their parents.
%
% Syntax:  NewChrom = xovmp(OldChrom, Px, Npt, Rs)
%
% Input parameters:
%    OldChrom  - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one individual
%                (in binary form).
%    Px        - Probability of recombination ocurring between pairs
%                of individuals.
%    Npt       - Scalar indicating the number of crossover points
%                1: single point crossover
%                2: double point crossover
%                0: shuffle point crossover
%    Rs        - reduced surrogate
%                0: no reduced surrogate
%                1: reduced surrogate
%
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mating, ready to be mutated and/or evaluated,
%                in the same format as OldChrom.
%
% See also: recombin, xovdp, xovsh, xovsp, xovdprs, xovsprs, xovshrs

% Author: Carlos Fonseca,   Updated: Andrew Chipperfield     Hartmut Pohlheim
% Date: 28/09/93,           Date: 27-Jan-94                  31.05.95

function NewChrom = xovmp(OldChrom, Px, Npt, Rs);

% Identify the population size (Nind) and the chromosome length (Lind)
   [Nind,Lind] = size(OldChrom);

% Set default parameters
   if Lind < 2, NewChrom = OldChrom; return; end

   if nargin < 4, Rs = []; end
   if nargin < 3, Npt = []; end
   if nargin < 2, Px = []; end
   if isnan(Px), Px = []; end
   if isnan(Npt), Npt = []; end
   if isnan(Rs), Rs = []; end
   if isempty(Px), Px = 0.7; end
   if isempty(Npt), Npt = 0; end
   if isempty(Rs), Rs = 0; end

   Xops = floor(Nind/2);
   DoCross = rand(Xops,1) < Px;
   odd = 1:2:Nind-1;
   even = 2:2:Nind;

% Compute the effective length of each chromosome pair
   Mask = ~Rs | (OldChrom(odd, :) ~= OldChrom(even, :));
   Mask = cumsum(Mask')';

% Compute cross sites for each pair of individuals, according to their
% effective length and Px (two equal cross sites mean no crossover)
   xsites(:, 1) = Mask(:, Lind);
   if Npt >= 2,
      xsites(:, 1) = ceil(xsites(:, 1) .* rand(Xops, 1));
   end
   xsites(:,2) = rem(xsites + ceil((Mask(:, Lind)-1) .* rand(Xops, 1) ) ...
                     .* DoCross - 1 , Mask(:, Lind) ) + 1;

% Express cross sites in terms of a 0-1 mask
   Mask = (xsites(:,ones(1,Lind)) < Mask) == (xsites(:,2*ones(1,Lind)) < Mask);

   if ~Npt,
      shuff = rand(Lind,Xops);
      [ans,shuff] = sort(shuff);
      for i=1:Xops
         OldChrom(odd(i),:)=OldChrom(odd(i),shuff(:,i));
         OldChrom(even(i),:)=OldChrom(even(i),shuff(:,i));
      end
   end

% Perform crossover
   NewChrom(odd,:) = (OldChrom(odd,:).* Mask) + (OldChrom(even,:).*(~Mask));
   NewChrom(even,:) = (OldChrom(odd,:).*(~Mask)) + (OldChrom(even,:).*Mask);

% If the number of individuals is odd, the last individual cannot be mated
% but must be included in the new population
   if rem(Nind,2), NewChrom(Nind,:)=OldChrom(Nind,:); end

   if ~Npt,
      [ans,unshuff] = sort(shuff);
      for i=1:Xops
         NewChrom(odd(i),:)=NewChrom(odd(i),unshuff(:,i));
         NewChrom(even(i),:)=NewChrom(even(i),unshuff(:,i));
      end
   end


% End of function
