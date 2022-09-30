function varargout=esmsg(BodyTextString,TitleString,IconString,OKCall,CloseCall,OKStr,CloseStr)
% varargout=esmsg(BodyTextString,TitleString,IconString,OKCall,CloseCall,OKStr,CloseStr)
% ESMSG  Display message box for the Evolution Strategy.
%   esmsg(Message) creates a message box that automatically wraps
%   Message to fit an appropriately sized Figure.  Message is a string
%   vector, string matrix or cell array.
%
%   esmsg(Message,Title) specifies the title of the message box.
%
%   esmsg(Message,Title,Icon) specifies which Icon to display in
%       the message box.  Icon is 'none', 'error', 'help', 'warn', 
%       'info', 'search' or 'es'. The default is 'none'.
%
%   esmsg(Message,Title,Icon,OKCall) specifies what to do if the
%       'OK'-Button is clicked
%
%   esmsg(Message,Title,Icon,OKCall,CloseCall) specifies what to do if the
%       'OK'- or 'Close'-Button is clicked
%
%   esmsg(Message,Title,Icon,OKCall,CloseCall,OKStr) specifies which name the
%       first button has to be labeled
%
%   esmsg(Message,Title,Icon,OKCall,CloseCall,OKStr,CloseStr) specifies which name the
%       second button has to be labeled.
%         
%   See also: MSGBOX, DIALOG, ERRORDLG, HELPDLG, TEXTWRAP, WARNDLG.


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargout>1,error('Too many output arguments for ESMSG.');end  
if nargin>7, error('Too many input arguments for ESMSG.'); end
  
if nargin < 5,
  CloseButton=0; CloseCall='';
  CloseStr='Close';OKStr='OK';
  if nargin < 4,
     OKCall='delete(get(0,''CurrentFigure''))';
     if nargin < 3,
        IconString='none';
        if nargin < 2,
          TitleString='';
          if nargin < 1,
             error('Too few input arguments for ESMSG.');
          end
        end
     end
  end
else,
  if ~isempty(CloseCall),
     CloseButton=1;
  else,
     CloseButton=0;  
  end
  if nargin==5, 
     CloseStr='Close';OKStr='OK';
  end
  if nargin==6, CloseStr='Close';end  
end

% Get a good font for buttons in this platform.
[fname,fsize] = bestfont(computer);
Std.Units='pixels';
Std.FontName=fname;
Std.FontSize=fsize;


IconString=lower(IconString);
if ~(strcmp(IconString,'none')|strcmp(IconString,'help')  ...
    |strcmp(IconString,'warn')|strcmp(IconString,'error') ...
    |strcmp(IconString,'search')...
    |strcmp(IconString,'info')|strcmp(IconString,'es')),
    warning('Invalid string for Icon in ESMSG.');
    IconString='none';
end

% set the color

Black      =[0       0        0      ]/255;
LightGray  =[192     192      192    ]/255;
LightGray2 =[160     160      164    ]/255;
MediumGray =[128     128      128    ]/255;
White      =[255     255      255    ]/255;
Red        =[255     0        0      ]/255;
Blue       =[0       0        255    ]/255;
Magenta    =[255     0        255    ]/255;


% Set Positions 

if strcmp(IconString,'none'),
  FigWidth=300;
else,
  FigWidth=350;
end
FigHeight=180;

OKWidth=50;
OKHeight=20;
OKXOffset=(FigWidth-OKWidth)/2;
OKYOffset=5;

MsgOff=5;

MsgTxtXOffset=MsgOff;
MsgTxtYOffset=MsgOff+OKYOffset+OKHeight;
MsgTxtWidth=FigWidth-2*MsgOff;
MsgTxtHeight=FigHeight-MsgOff-MsgTxtYOffset;
MsgTxtForeClr=Black;

IconWidth=32;
IconHeight=32;
IconXOffset=MsgTxtXOffset;
IconYOffset=FigHeight-MsgOff-IconHeight;


if ~strcmp(IconString,'none'),
  IconOff=IconXOffset+IconWidth+MsgOff;
  MsgTxtXOffset=MsgTxtXOffset+IconOff;
  MsgTxtWidth=MsgTxtWidth-IconOff;
end % if ~strcmp


% Create MsgBox 

BoxHandle=choice5(TitleString,FigWidth,FigHeight,[0 .78 .8],'off','off');
set(BoxHandle,'NextPlot','add','HandleVisibility','on',...
    'WindowStyle','normal','Tag',TitleString);

DefFigPos=get(BoxHandle,'pos');
FigColor=get(BoxHandle,'Color');

MsgTxtBackClr=FigColor;

FrameHndl=uicontrol('Style','frame','Units','pixels',...
   'pos',[2 1 FigWidth-4 OKHeight+6],'Back','b');

if ~CloseButton,
   OKHandle=uicontrol(BoxHandle, 'Style','push','Units','pixels', ...
       'Pos',[ OKXOffset OKYOffset-1 OKWidth  OKHeight],...
       'Call',OKCall,'String',OKStr,'HorizontalAlignment','center', ...
       'Tag','OKButton');
     
else,
   OKXOffset=(FigWidth-2*OKWidth)/3;
   CloseHandle=uicontrol(BoxHandle,'Style','push','Units','pixels', ...         
       'Pos',[ OKXOffset OKYOffset-1 OKWidth   OKHeight], ...
       'Call',CloseCall,'String',CloseStr, ...
       'HorizontalAlignment','center','Tag','CloseButton');
   OKHandle=uicontrol(BoxHandle,'Style','push','Units','pixels', ...       
       'Pos',[ OKWidth+2*OKXOffset OKYOffset-1 OKWidth   OKHeight], ...
       'Call',OKCall,'String',OKStr, ...
       'HorizontalAlignment','center','Tag','OKButton');
end               
               
MsgHandle=uicontrol(BoxHandle,'Style','text','Units','pixels', ...
       'Pos',[MsgTxtXOffset MsgTxtYOffset 0.95*MsgTxtWidth MsgTxtHeight],...
       'String',' ','Tag','MessageBox','HorizontalAlignment','left', ...    
       'Back',MsgTxtBackClr,'FontWeight','normal','Fore',MsgTxtForeClr);

               
TempObj=copyobj(MsgHandle,get(MsgHandle,'Parent'));
set(TempObj,'Visible','off','Max',100,'String',BodyTextString);
NewMsgTxtPos=get(TempObj,'Extent');
NumLines=size(BodyTextString,1);
 
if NewMsgTxtPos(3)>MsgTxtWidth,
  DiffWidth=NewMsgTxtPos(3)-MsgTxtWidth;
  
  MsgTxtWidth=NewMsgTxtPos(3);
  
  FigWidth=FigWidth+DiffWidth;
  set(FrameHndl,'pos',[2 1 FigWidth-4 OKHeight+6]);
  DefFigPos(3)=FigWidth;
  if ~CloseButton, 
     OKXOffset=(FigWidth-OKWidth)/2;
     OKPos=get(OKHandle,'Position');
     OKPos(1)=OKXOffset;
     set(OKHandle,'Position',OKPos);
  else,
     OKXOffset=(FigWidth-2*OKWidth)/3;
     ClosePos=get(CloseHandle,'Position');
     ClosePos(1)=OKXOffset;
     set(CloseHandle,'Position',ClosePos);
     OKPos=get(OKHandle,'Position');
     OKPos(1)=3*OKXOffset;
     set(OKHandle,'Position',OKPos);
  end  
end % if NewInfFrmPos

if NewMsgTxtPos(4)>MsgTxtHeight,
  DiffHeight=NewMsgTxtPos(4)-MsgTxtHeight;
  
  MsgTxtHeight=NewMsgTxtPos(4);
  
  FigHeight=FigHeight+DiffHeight;
  DefFigPos(4)=FigHeight;
  
  IconYOffset=IconYOffset+DiffHeight;
  
end % if NewInfFrmPos

set(BoxHandle,'Position',DefFigPos);
  
set(MsgHandle,'Max',NumLines,'String',BodyTextString,...
   'Pos',[MsgTxtXOffset MsgTxtYOffset MsgTxtWidth MsgTxtHeight]);
   

if ~strcmp(IconString,'none'),
  IconAxes=axes('Parent',BoxHandle,'Units','pixels', ...
        'Pos',[IconXOffset IconYOffset IconWidth IconHeight], ...
        'NextPlot','replace', ...
        'HandleVisibility','on','Tag','IconAxes');         
 

  IconCMap=[Black;FigColor];
  
  if strcmp('warn',IconString),
    IconData= ...
   [2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
    2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
    2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
    2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2 2;
    2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2 2;
    2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2;
    2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 3 3 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 2 2 1 1 2 2 3 3 3 3 2 2 1 1 2 2 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 2 2 1 1 2 2 3 3 3 3 2 2 1 1 2 2 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 2 1 1 2 2 2 3 3 3 3 2 2 2 1 1 2 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 2 1 1 2 2 2 3 3 3 3 2 2 2 1 1 2 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 1 1 2 2 2 2 3 3 3 3 2 2 2 2 1 1 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 1 1 2 2 2 2 3 3 3 3 2 2 2 2 1 1 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 1 1 2 2 2 2 2 3 3 3 3 2 2 2 2 2 1 1 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 1 1 2 2 2 2 2 3 3 3 3 2 2 2 2 2 1 1 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 1 1 2 2 2 2 2 2 3 3 3 3 2 2 2 2 2 2 1 1 2 2 2 2 2 2; 
    2 2 2 2 2 2 1 1 2 2 2 2 2 2 3 3 3 3 2 2 2 2 2 2 1 1 2 2 2 2 2 2; 
    2 2 2 2 2 1 1 2 2 2 2 2 2 2 3 3 3 3 2 2 2 2 2 2 2 1 1 2 2 2 2 2; 
    2 2 2 2 2 1 1 2 2 2 2 2 2 2 2 3 3 2 2 2 2 2 2 2 2 1 1 2 2 2 2 2;
    2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 3 3 2 2 2 2 2 2 2 2 2 1 1 2 2 2 2;
    2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2 2;
    2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2;
    2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 3 3 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2;
    2 2 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 2 2 2 2 2 2 2 2 2 2 1 1 2 2;
    2 2 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 2 2 2 2 2 2 2 2 2 2 1 1 2 2;
    2 1 1 2 2 2 2 2 2 2 2 2 2 2 2 3 3 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2;
    2 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2;
    1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1;
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2];

    IconCMap=[Red;FigColor;Black];

  elseif strcmp('help',IconString),
    IconData= ...
   [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    1 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    1 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    1 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    1 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    1 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 1 1 1 1 1 1 1 1; 
    1 2 2 2 1 2 2 2 2 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1; 
    1 2 2 2 1 2 2 2 2 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1; 
    1 2 2 2 1 2 2 2 2 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1; 
    1 2 2 2 2 2 2 2 2 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1; 
    1 2 2 2 2 2 2 2 2 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1; 
    1 2 2 2 2 2 2 2 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1; 
    1 2 2 2 2 2 2 2 2 1 1 1 2 2 2 1 1 1 2 1 1 1 2 1 1 1 2 2 2 2 1 1; 
    1 2 2 2 2 2 2 2 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1; 
    1 2 2 2 2 2 2 2 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1; 
    1 2 2 2 2 2 2 2 2 1 1 1 2 2 2 1 1 1 2 1 1 1 2 1 2 1 2 2 2 2 1 1; 
    1 2 2 2 2 2 2 2 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1; 
    1 2 2 2 2 2 2 2 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1; 
    1 2 2 2 2 2 2 2 2 1 1 1 2 2 2 1 1 1 2 1 2 1 1 1 2 2 2 2 2 2 1 1; 
    1 2 2 2 2 2 2 2 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1; 
    1 2 2 2 2 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1; 
    1 2 2 2 2 2 2 1 1 1 1 1 2 2 2 1 1 1 1 2 1 1 1 2 1 1 2 2 2 2 1 1; 
    1 2 2 2 2 2 2 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1; 
    1 2 2 2 2 2 2 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1; 
    1 2 2 2 2 2 2 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1; 
    1 2 2 2 2 2 2 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1; 
    1 2 2 2 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1; 
    1 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

  elseif strcmp('error',IconString),
    IconData= ...
   [2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2; 
    2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2; 
    2 2 2 2 1 1 1 1 1 1 1 1 1 1 2 2 2 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2; 
    2 2 2 1 1 1 1 1 1 1 1 2 1 1 2 2 2 1 1 2 2 1 1 1 1 1 1 1 1 2 2 2; 
    2 2 1 1 1 1 1 1 1 1 2 2 2 1 2 2 2 1 2 2 2 1 1 1 1 1 1 1 1 1 2 2; 
    2 1 1 1 1 1 1 1 1 1 2 2 2 1 2 2 2 1 2 2 2 1 1 1 1 1 1 1 1 1 1 2; 
    1 1 1 1 1 1 1 1 2 1 2 2 2 1 2 2 2 1 2 2 2 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 1 2 2 2 1 2 2 2 1 2 2 2 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 1 2 2 2 1 2 2 2 1 2 2 2 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 1 2 2 2 1 2 2 2 1 2 2 2 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 1 2 2 2 1 2 2 2 1 2 2 2 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 1 2 2 2 1 2 2 2 1 2 2 2 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 1 2 2 2 2 2 2 2 2 2 2 2 1 1 1 2 2 2 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2 2 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2 2 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 2 2 2 2 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1; 
    2 1 1 1 1 1 1 2 2 2 2 2 2 1 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 2; 
    2 2 1 1 1 1 1 1 2 2 2 2 2 2 1 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 2 2; 
    2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2; 
    2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2; 
    2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2; 
    2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2];
    
    IconCMap=[Red;FigColor];

  elseif strcmp('search',IconString),
    load search; IconCmap=[Red;FigColor;Red;Red];

  elseif strcmp('info',IconString),
    IconData= ...
   [2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 3 3 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2; 
    2 2 2 2 2 1 1 1 1 1 1 1 1 1 3 3 3 3 1 1 1 1 1 1 1 1 1 2 2 2 2 2; 
    2 2 2 2 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 2 2 2 2; 
    2 2 2 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 2 2 2; 
    2 2 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 2 2; 
    2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 1 3 3 1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1; 
    2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 2; 
    2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2; 
    2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2; 
    2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2; 
    2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2; 
    2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2];
    
    IconCMap=[Magenta;FigColor;Blue];

  elseif strcmp('es',IconString),
     [IconData, IconCMap] = imread('eslogo.bmp');
  end 
  Img=image('CData',IconData,'Parent',IconAxes); 

  set(BoxHandle, 'Colormap', IconCMap);
  set(IconAxes      , ...
      'XLim'        ,get(Img,'XData')+[-0.5 0.5], ...
      'YLim'        ,get(Img,'YData')+[-0.5 0.5], ...
      'Visible'     ,'off'                      , ...
      'YDir'        ,'reverse'                  , ...      
      'HandleVisibility','on'                         ...
      );
  
end % if ~strcmp

set(BoxHandle,'HandleVisibility','on','Visible','on');

if nargout==1,varargout{1}=BoxHandle;end


