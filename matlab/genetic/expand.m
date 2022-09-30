function Ae = expand(A,n)
% EXPAND Expand matrix in both direction.
%	AE = EXPAND(A,[M N]) Returns matrix AE
%	of the size  M*size(A,1) by N*size(A,2)
%	in which each element of A is repeated
%	M times in rows and N times in columns.
%
%	Example:
%	expand([1 2; 3 4],[2 3])
%	ans =
%	 
%	     1     1     1     2     2     2
%	     1     1     1     2     2     2
%	     3     3     3     4     4     4
%	     3     3     3     4     4     4

%  Kirill K. Pankratov, kirill@plume.mit.edu
%  04/04/95

 % Handle input ..................................
if nargin==0, help expand, return, end
if n==[] | any(n<0)
  error(' Expansion must be 1 or 2 positive numbers [M N].')
end

 % If expansion in rows and columns is equal
if length(n)<2, n = [n(1) n(1)]; end

sz = size(A);

 % Expand in rows ....................
v = (1:sz(1));
ve = v(ones(n(1),1),:);
Ae = A(ve(:),:);

 % Expand in columns .................
v = (1:sz(2));
ve = v(ones(n(2),1),:);
Ae = Ae(:,ve(:));

