function fg=choice5(name,mywidth,myheight,mycolor,Resize,Vis)
% fg=choice5(name,mywidth,myheight,mycolor,Resize,Vis)
% CHOICE5.M to create a Window with:
%     - the Name <name>
%     - the fixed dimension (in pixels) (in difference to CHOICE4.m)
%     - in center of the screen
%     - Resize = 'on', if resize of the window is allowable
%                'off', else 
% Default Resize='off';  

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin <6,
  Vis='on';
  if nargin <5,
     Resize='off';
     if nargin<4,
        mycolor='black';
        if nargin <3,
           error('ERROR: At least 3 input arguments required?'); 
        end
     end 
  end 
end

%Determination the Size of Screen in Pixels
ssunit=get(0,'units');
set(0,'units','Pixels'); 
ss = get(0,'ScreenSize');
set(0,'units',ssunit);
myleft=(ss(3)-mywidth)/2;
mybottom=(ss(4)-myheight)/2;

fg=figure('units','pixels','visible',Vis,...
          'Position',[myleft,mybottom,mywidth,myheight],'numbertitle','off',...
          'name',name,'Menubar','none','Color',mycolor,'Resize',Resize);
