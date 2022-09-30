function n=recpair(nI,nrow,ncol,kwahl),
% n=recpair(nI,nrow,ncol,kwahl)
% to produce a random matrix with nrow rows and ncol columns
% so that all its elements have the integer value lower as nI
% kwahl=0  or 1 for uniform or normal distribution
%
% See also: REPROD.M and MUTB.M


% All Rights Reserved
% To Thanh Binh IFAT University of Magdeburg Germany, Oct.1995

if nargin ~=4,
   error('Four input arguments required!')
end

if kwahl==1,
     n=ceil(nI*rand(nrow,ncol));
else,
     temp=abs(randn(nrow,ncol));
     temp=temp/max(max(temp));
     n=ceil(nI*temp);
end
