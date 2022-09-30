function [fname,fsize] = bestfont(computer)
%       Returns a good font for a GUI on this platform

% fname - string
% fsize - points

switch computer

case 'PCWIN'
   fname = 'Helvetica';  %'Courier';
   fsize = 8;

case 'MAC2'
   fname = 'Monaco';
   fsize = 9;
   
case 'GLNXA64'
   fname = 'Helvetica';  %'Courier';
   fsize = 10;        

otherwise
   fname = 'Helvetica';
   fsize = 12;

end



