function vlchoice(nrows,callback,name)
% vlchoice(nrows,callback,name)
% This function is not intended to  be called directly by users.
% It performs the opening a window for chosing the
% weighting factors of each criteria (objective function)
%
% nrows    - number of rows to be described
%            (i.e. number of the parameter to be inputed)
%            normally nrows is equal to the number of obj. functions (mf)
%
%            In the case nrows=mf+1, we want to input else the parameter p
%            e.g. for evdialog('lpnorm')   (choose  using Lp-norm method)
%                     evdialog('goal')     (choose using the goal programming)
%                     evdialog('germeier') (choose using Germeier Methode)
% callback - a collection of commands to be called.
%
% name - the name of the choosing figure
%

% SEE ALSO: EVDIALOG.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin < 2,
   error('At least two input arguments required?');
elseif nargin < 3,
   name='Choose Weighting Factors';
end

pg=get(findobj('name','Dialog to the obtained Pareto-Set'),'UserData');
mf=pg{1}(1);
sunit=get(0,'Units');
set(0,'units','Pixels'); ss=get(0,'ScreenSize');mywidth=320;
myheight=110+(nrows-2)*30;
set(0,'Units',sunit);
rect = [.5*(ss(3)-mywidth),.5*(ss(4)-myheight),mywidth,myheight];
figure('units','pixels','Pos',rect,'numbertitle','off','Resize','off', ...
       'name',name,'Menubar','none','Color',[0 1 1]);
    
for i= mf-1:-1:1,
   String=['For the ' int2str(i) '-th objective function '];
   uicontrol('units','pixels','Style','text',...
             'Pos',[30,45+(mf-i)*30, 200, 20],...
             'Back',[.8 .8 .8],...
             'HorizontalAlignment','left',...
             'Fore','black','String',String);
   uichndl(i)=uicontrol('units','pixels','Style','edit',...
             'Pos',[250,45+(mf-i)*30, 40, 20],...
             'Back','white','String',num2str([]));
end 

if nrows ~=mf,
   String=['For the exponent parameter '];
   uicontrol('units','pixels','Style','text','Pos',[30,45+mf*30, 200, 20],...
             'Back',[.8 .8 .8],'HorizontalAlignment','left',...
             'Fore','black','String',String);
   hndl=uicontrol('units','pixels','Style','edit','Pos',[250,45+mf*30, 40, 20],...
             'Back','white','String',num2str([]));
   uichndl=[hndl,uichndl];
end

set(gcf,'UserData',uichndl);

uicontrol('units','pixels','Style','push','String','OK','Pos',[190,5, 50, 20],...
         'callback',callback);

uicontrol('units','pixels','Style','push','String','Close','Pos',[80,5, 50, 20],...
         'callback','close(gcf)');
  
