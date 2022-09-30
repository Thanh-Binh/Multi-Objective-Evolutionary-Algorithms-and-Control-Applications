function Astr=matostr(A,ndec)
% Astr=matostr(A,ndec)
% Matrix to String Conversion
%
% Returns a string matrix Astr, sized [nrows,(ndec+8)*ncols]
% where [nrows,ncols]=size(A). Astr contains string representations
% of elements of A with n decimal places and can be displayed
% as a text in gca.
%
% For example:
%    MATOSTR(magic(3)) produces a text:
%         8     1     6
%         3     5     7
%         4     9     2


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


[n,m]=size(A);
if nargin==1, ndec=4;end
Length=length(mat2str(floor(max(max(abs(A))))));
mw=ndec+Length+1;
for i=1:n
  SS=[];
  for j=1:m
    eval(['S=sprintf(''%.' int2str(ndec) 'g'',A(i,j));'])
    ls=length(S);
    if ls>=mw,
        S=S(1:mw);
    else,
        S=[32*ones(1,mw-ls) S];
    end
      
    SS=[SS 32*ones(1,3) S];
  end
  Astr(i,:)=SS;
end

