function essave(oldname)
% essave(oldname)
% GUI for input the file name in which the obtained results
% can be saved. 
% OLDNAME - a temporary save file of the evolution strategy
% Algorithm: rename the OLDNAME-file

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany

% Get a good font for buttons in this platform.
[fname,fsize] = bestfont(computer);
Std.Units='norm';
Std.FontName=fname;
Std.FontSize=fsize;

choice5('Name of mat-file',200,100,[.4 .8 .8],'off');
uicontrol(Std,'Style','text','Pos',[.1 .7 .8 .2],'Back',[.4 .8 .8],...
   'String','Please input a name:','Fore','r','HorizontalAlignment','left');
new=uicontrol(Std,'Style','edit','Pos',[.1 .45 .8 .25],...
   'String',oldname,'Back','white');

set(gcf,'UserData',{new, oldname});
uicontrol(Std,'Style','push','String','OK',...
   'Pos',[.6 .05 .2 .2],'callback',[... 
   'pl=get(gcf,''UserData'');',...
   'filename=get(pl{1},''string'');',...
   'mrename(pl{2},filename);',...
   'close(gcf)']);

uicontrol(Std,'Style','push','String','Close','Pos',[.2 .05 .2 .2],...
   'callback','close(gcf)');
