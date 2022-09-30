function Astr=strpmat(A,Lstr,Ostr)
% Astr=mat2text(str,A)
% Convert a Matrix to Text so that this text can be written in a m-file
% or executed in matlab regulare prompt.
%
% The string can be represented with a maximum N digits of precision.  
% The default number of digits is
% based on the magnitude of the elements of A.
%
% Example:
%   For A=[1.0234 2.5678;3.01 4], Astr=mat2text(A,'NAME') produces the
%   string matrix 
%            Astr='NAME=[1.0234, 2.5678;...
%                          3.01,      4];'

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


[n,m]=size(A);
  
%d = min(11,max(1,max(ceil(log10(abs(A(:))+(A(:)==0))))))+4;
d=4;
f = ['%' int2str(d+6) '.' int2str(d) 'g'];

Astr='';
for i=1:n
  SS=[];
  for j=1:m
     if i==1, 
        Ostrn=str2num(deblank(Ostr(j,:)));
        SS=[SS sprintf(f,Ostrn)];
     else,
        SS=[SS sprintf(f,A(i,j))];
     end
     if j~=m, SS=[SS 32];end
  end
  Astr=strvcat(Astr,SS);
end
if nargin == 2
   if size(str,1)~=n,
      error('Matrix and string must have the same number of rows');
   else,
      Astr=[str,Astr];
   end
end