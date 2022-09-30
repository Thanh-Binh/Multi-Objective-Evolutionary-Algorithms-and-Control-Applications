function Astr=cmat2str(A,ndec,nspace)
% Astr=cmat2str(A,ndec,nspace)
% Matrix to String Conversion
%
% Extension of num2str to matrices.
%
% Returns a string matrix Astr, sized [nrows,(ndec+8)*ncols]
% where [nrows,ncols]=size(A). Astr contains string representations
% of elements of A with n decimal places.
%
% Caveat: the routine 'sprintf's entire matrix rows,
%         so the screen rows may overflow when you display
%         the resultant Astr.
%
% Slow but useful when displaying badly scaled matrices
% (with big range of elements' values).
% max. width :  ndec+7
% 
% See also BSTR2MAT


% To Thanh Binh, IFAT, University of Magdeburg, Germany
% All Rights Reserved, March 1996

[n,m]=size(A);
spac='         ';
if nargin<3, nspace=7;end
if nargin<2, ndec=4;end

mw=ndec+nspace;
for i=1:n
  SS=[];
  for j=1:m
    eval(['S=sprintf(''%.' int2str(ndec) 'g'',A(i,j));'])
    ls=length(S);
    if ls<mw
      S=[spac(1:floor((mw-ls)/2)) S spac(1:ceil((mw-ls)/2))];
    end
    SS=[SS ' ' S];
  end
  %disp(SS)
  Astr(i,:)=SS;
end

