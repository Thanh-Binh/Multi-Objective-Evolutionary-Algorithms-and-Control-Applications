function  lc_call1(num,pol)
% lc_call1(num,pol)
% This function is not intended to call directly from users.
%
% See also DESIGN.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin <2, pol=0;end

fud=get(findobj('tag','DesignMainFig'),'Userdata');
pl=get(fud{1}(num),'Userdata');

if ~get(fud{1}(num),'value'),  %reset performance
    set(pl,'vis','off');set(pl(1),'value',0);
    set(pl(2),'value',0);set(pl(3),'Fore','b');
    perform_type=get(fud{1}(16),'UserData');
    perform_type{num-6}=[NaN];
    if pol, 
       set(fud{1}(num),'String','Pole Region Type','Value',0);
    end
    set(fud{1}(16),'UserData',perform_type);

else,
    set(pl,'vis','on');set(pl(3),'Enable','off');
    if pol, 
       poleopt('init');
    else,
       design('setindx',num-6,fud{1}(16)); 
    end

end
