function  lc_call(num,state,requirement)
% lc_call(num,state,requirement)
% This function is not intended to call directly from users.
%
% See also DESIGN.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany



fud=get(findobj('tag','DesignMainFig'),'Userdata');
pl=get(fud{1}(num),'Userdata');
set(pl(3),'Enable',state,'Fore','b');
perform_type=get(fud{1}(16),'UserData');

if strcmp(requirement,'obj'),
   tmp=[1,2];
   perform_type{num-6}(1)=1;
elseif strcmp(requirement,'cons'),
   tmp=[2,1];
   perform_type{num-6}(1)=0;
end

if get(pl(tmp(1)),'value') == 1,
  set(pl(tmp(2)),'value',0);
else,
  set(pl(tmp(1)),'value',1);
end

set(fud{1}(16),'UserData',perform_type);
