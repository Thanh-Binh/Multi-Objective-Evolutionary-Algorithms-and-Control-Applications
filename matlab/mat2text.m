function Astr=mat2text(A,name)
% Astr=mat2text(A,name)
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
if nargin < 2, 
  name='';
end
namelength=length(name);
  
d = min(11,max(1,max(ceil(log10(abs(A(:))+(A(:)==0))))))+4;
f = ['%' int2str(d+6) '.' int2str(d) 'g'];

Astr='';
for i=1:n
  SS=[];
  for j=1:m
     SS=[SS sprintf(f,A(i,j))];
     if j~=m, SS=[SS 44];end
  end
  Astr=strvcat(Astr,SS);
end


% Remove leading blanks
if ~isempty(Astr)
   while all(Astr(:,1) == ' '), Astr(:,1) = []; end
end

% If it's a scalar remove the trailing blanks too.
if length(A)==1,
   Astr = [name deblank(Astr) 59];return,
end

if n==1,
   Astr=[name 91 Astr 93 59];return,
else
   Astr1=[name 91];Astrn=[93 59 32 32];
   for i=1:n-1, 
     Astr1=[Astr1;32*ones(1,namelength+1)];
     Astrn=[59 46 46 46;Astrn];
   end
end
Astr=[Astr1,Astr,Astrn];
