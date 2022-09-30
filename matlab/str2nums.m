function [sign,value]=str2nums(str)
% [sign,value]=str2nums(str)
% Convert a STRing mit the sign '>' or '>=' or '<' or '<=' or '='
% into a decimal value mit appropriate sign
%
% str - a string of the sign and decimal number
%
% sign = 10   for the sign '>='
% sign = 1    for the sign  '>'
% sign = 0    for the sign '=' or ' '
% sign = -1   for the sign '<'
% sign = -10  for the sign '<='
%
% for example:  str=' > 1.4567 ';
%      we get   sign = 1; value= 1.4567
%
% SEE ALSO: EVDIALOG.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



if (nargin ~= 1),
    error('Only one string input required!'),
    return,
end
if ~isstr(str),
    error('A string input required!'),
    return,
end

str=str(find(str~=' '));
lengthstr=length(str);
if strcmp(str(1),'>'),
    if strcmp(str(2),'='),
       sign=10; value=str2num(str(3:lengthstr));
    else,
       sign=1; value=str2num(str(2:lengthstr));
    end
elseif strcmp(str(1),'<'),
    if strcmp(str(2),'='),
       sign=-10; value=str2num(str(3:lengthstr));
    else,
       sign=-1; value=str2num(str(2:lengthstr));
    end
else            %  str(1)='' or str(1)='='
    sign=0; value=str2num(str);
end

