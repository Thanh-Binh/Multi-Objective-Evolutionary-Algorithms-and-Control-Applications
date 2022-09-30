% CReaTe an initial Binary/integer Population
%
% This function creates a binary/integer population of given size and structure.
%
% Syntax: [Chrom Lind BaseV] = crtbp(Nind, Lind, Base)
%
% Input Parameters:
%    Nind      - Either a scalar containing the number of individuals
%                in the new population or a row vector of length two
%                containing the number of individuals and their length.
%    Lind      - A scalar containing the length of the individual
%                chromosomes.
%    Base      - A scalar containing the base of the chromosome 
%                elements or a row vector containing the base(s) 
%                of the locci of the chromosomes.
%
% Output Parameters:
%    Chrom     - A matrix containing the random valued chromosomes 
%                row wise.
%    Lind      - A scalar contatining the length of the chromosome.
%    BaseV     - A row vector containing the base of the 
%                chromosome locci.
%
% See also: crtbase, crtrp, bin2real, bin2int, mutbint

% Author: Andrew Chipperfield       Hartmut Pohlheim
% Date:	19-Jan-94                  31.05.95


function [Chrom, Lind, BaseV] = crtbp(Nind, Lind, Base)

% Check parameter consistency
   nargs = nargin;
   if nargs >= 1, [mN, nN] = size(Nind) ; end
   if nargs >= 2, [mL, nL] = size(Lind) ; end
   if nargs == 3, [mB, nB] = size(Base) ; end

   if nN == 2
      if (nargs == 1) 
         Lind = Nind(2) ; Nind = Nind(1) ; BaseV = crtbase(Lind) ;
      elseif (nargs == 2 & nL == 1) 
         BaseV = crtbase(Nind(2),Lind) ; Lind = Nind(2) ; Nind = Nind(1) ; 
      elseif (nargs == 2 & nL > 1) 
         if Lind ~= length(Lind), error('Lind and Base disagree'); end
         BaseV = Lind ; Lind = Nind(2) ; Nind = Nind(1) ; 
      end
   elseif nN == 1
      if nargs == 2
         if nL == 1, BaseV = crtbase(Lind) ;
         else, BaseV = Lind ; Lind = nL ; end
      elseif nargs == 3
         if nB == 1, BaseV = crtbase(Lind,Base) ; 
         elseif nB ~= Lind, error('Lind and Base disagree') ; 
         else BaseV = Base ; end
      end
   else
      error('Input parameters inconsistent') ;
   end

% Create a structure of random chromosomes in row wise order, dimensions
% Nind by Lind. The base of each chromosomes loci is given by the value
% of the coresponding element of the row vector base.

   Chrom = floor(rand(Nind,Lind).*BaseV(ones(Nind,1),:)) ;


% End of function
