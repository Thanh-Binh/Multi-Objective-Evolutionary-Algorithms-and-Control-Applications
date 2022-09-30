function [newfile,num]=fcreate(filename,type)
% [newfile,num]=fcreate(filename,type)
% 
% Inputs:
%   FILENAME - name of the file (string)
%   TYPE     - type of the file (string like 'm' for m-file,'mat' for mat-file)
%
% Outputs:
%   NEWFILE  - name of the new file
%   NUM      - index of new file (indicates how many time the FILENAME
%              has been calling from user)
%
% This function is used to check if the file named <<filename>> exists
% in the MATLAB's search path.
% if file exists,  it creates a new file with the new number.
% For example:
%      filename='myname' und type='m'
%      if file myname.m exists, it searchs for the file named 'myname1.m', 
%      until the file mynamei.m does not exist. Then return
%                 newfile='mynamei';

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 


if nargin < 1, error('Too few inputs');end

num=0; test=0;newfile=filename;
while ~test,
   if num,
      newfile=[filename,num2str(num)];
   end
   if ~exist([newfile,'.',type],'file'),
       test=1;
   else,
       num=num+1;
   end
end
