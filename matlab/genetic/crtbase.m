% CReaTe BASE vector for binary/integer population creation 
%
% This function creates a vector containing the base of the loci
% in a chromosome.
%
% Syntax: BaseVec = crtbase(Lind, Base)
%
% Input Parameters:
%    Lind      - A scalar or vector containing the lengths
%                of the Alleles.  Sum(Lind) is the length of
%                the corresponding chromosome.
%    Base      - A scalar or vector containing the base of
%                the loci contained in the Allels.
%
% Output Parameters:
%    BaseVec   - A vector whose elemets corespond to the base
%                of the loci of the associated chromosome structure.
%
% See also: crtbp, bin2real, bin2int, mutbint

% Author: Andrew Chipperfield       Hartmut Pohlheim
% Date: 19-Jan-94                   31.05.95


function BaseVec = crtbase(Lind, Base)

% Set default parameters
   [ml LenL] = size(Lind) ;
   if nargin < 2 
      Base = 2 * ones(LenL,1) ; % default to base 2
   end
   [mb LenB] = size(Base) ;

% Check parameter consistency
   if ml > 1 | mb > 1
   	error( 'Lind or Base is not a vector') ;
   elseif (LenL > 1 & LenB > 1 & LenL ~= LenB) | (LenL == 1 & LenB > 1 ) 
   	error( 'Vector dimensions must agree' ) ;
   elseif LenB == 1 & LenL > 1
   	Base = Base * ones(LenL,1) ;
   end

% Create base vector
   BaseVec = [] ;
   for i = 1:LenL
   	BaseVec = [BaseVec, Base(i)*ones(Lind(i),1)'];
   end


% End of function
