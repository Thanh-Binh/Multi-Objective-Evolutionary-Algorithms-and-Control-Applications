function eshlpfun(hlpname,titleStr,helpStr);
% Evolution Strategy HeLP FUNction is used to display
% multi pages help text with the different topics
% on the text window
%
% hlpname - Name of the help window
% titleStr- a cell including topics
% helpStr - a cell for multi page text

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin <3,
   error('Three Input Arguments at least required.');
end
numPages=size(helpStr,2);

ttlSize=size(titleStr,1);

if (ttlSize == 1),
   for i=1:numPages, TitleStr{i}=titleStr; end
end
if (ttlSize >1),
   if (numPages ~= ttlSize),
      error('Number of Titles must be equal Number of Pages.');
   else
      TitleStr=titleStr;
   end
end

Pagenumber=1;

% Get a good font for this platform.
[fname,fsize] = bestfont(computer);
Std.Units='norm';
Std.FontName=fname;
Std.FontSize=fsize;

% If the Help Window has already been created, bring it to the front
figNumber=findobj('name',hlpname);

if isempty(figNumber),

    set(0,'Units','Pixels'); ss=get(0,'ScreenSize');
    mywidth=700;myheight=560;
    mybottom = .5*(ss(4)-myheight);
    myleft = .5*(ss(3)-mywidth);
    position=[myleft mybottom mywidth myheight];

    figNumber=figure('Name',hlpname,'Numbertitle','off', ...
        'HandleVisibility','on','Visible','off', ...
	'Pos',position, 'Menubar','none', ...
	'Color',[.5 0 0],'Resize','off');

    % Set up the Help Window
    top=0.97;
    left=0.02;
    right=0.78;
    bottom=0.03;
    labelHt=0.03;  
    spacing=0.005;

    % Then the text label
    labelPos=[left-.01 top-labelHt-.01 (right-left+.02) labelHt+.03];
    uicontrol('Style','frame','Units','norm','Pos',labelPos,'Back',[0.4 0.8 0.8]);

    labelPos=[left+.01 top-labelHt (right-left-.02) labelHt];
    ttlHndl=uicontrol(Std,'Style','text','Pos',labelPos,...
        'Back',[0.4 0.8 0.8],'Fore','b','String',deblank(TitleStr{1}));

    AxesPos=[left-.01 bottom-.02 (right-left+.02) top-bottom-labelHt+.01];
    axes(Std,'Color',[1 1 1],'Pos',AxesPos,'XGrid','off','YGrid','off',...
        'TickLength',[0 0],'Xtick',[],'Ytick',[],...
        'ydir','reverse','clipping','on','nextplot','add');

    HlpTextHndl=text(Std,'pos',[.03,.97],'String',helpStr{1},...
        'VerticalAlignment','top','HorizontalAlignment','left');

    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    yInitPos=0.80;top=0.97;
    left=0.82;
    btnWid=0.15;
    btnHt=0.08;
    % Spacing between the button and the next command's label
    spacing=0.05;

    % The CONSOLE frame
    frmBorder=0.02;
    yPos=bottom-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder top-bottom+2*frmBorder];
    uicontrol('Style','frame','Units','norm','Pos',frmPos,'Back',[0.4 .8 0.8]);

    % All required BUTTONS
    % The callback will turn off ALL text fields and then turn on
    % only the one referred to by the button.

    callbackStr= ...
      ['figud=get(gcf,''UserData'');', ...
       'numPages=figud.num{1};Pagenumber=figud.num{2};',...
       'if Pagenumber > 1,',...
          'Pagenumber=Pagenumber-1;',...
          'set(figud.num{3},''String'',figud.Title{Pagenumber});', ...
          'set(figud.num{4},''String'',figud.Text{Pagenumber});', ...
          'figud.num{2}=Pagenumber;',...
          'set(gcf,''UserData'',figud);',...
       'end'];

    btnHndlList(1)= uicontrol(Std,'Style','push', ...
       'Pos',[left top-btnHt btnWid btnHt],'String','Back', ...
       'Callback',callbackStr);

    callbackStr= ...
      ['figud=get(gcf,''UserData'');', ...
       'numPages=figud.num{1};Pagenumber=figud.num{2};',...
       'if Pagenumber < numPages,',...
          'Pagenumber=Pagenumber+1;',...
          'set(figud.num{3},''String'',figud.Title{Pagenumber});', ...
          'set(figud.num{4},''String'',figud.Text{Pagenumber});', ...
          'figud.num{2}=Pagenumber;',...
          'set(gcf,''UserData'',figud);',...
       'end'];
 
    btnHndlList(2)= uicontrol(Std,'Style','push', ...
       'Pos',[left top-2*btnHt-spacing btnWid btnHt], ...
       'String','Next','Callback',callbackStr);


    % The CLOSE button
    uicontrol(Std,'Style','push','Pos',[left 0.05 btnWid btnHt], ...
        'String','Close','Callback','set(gcf,''visible'',''off'');');
 
    figud.num={numPages Pagenumber ttlHndl HlpTextHndl btnHndlList};
    figud.Title=TitleStr;
    figud.Text=helpStr;
    set(figNumber,'visible','on','UserData',figud);
    if numPages==1, set(figud.num{5},'visible','off');set(figud.num{6},'visible','off');end 

else,

    figud=get(figNumber,'UserData');
    figud.num{1}=numPages;figud.num{2}=Pagenumber;
    figud.Title=TitleStr;
    figud.Text=helpStr;
    set(figud.num{3}, 'String', TitleStr{Pagenumber});
    set(figud.num{4}, 'String', helpStr{Pagenumber});
    set(figNumber,'visible','on','UserData',figud);
    if numPages==1, set(figud.num{5},'visible','off');set(figud.num{6},'visible','off');end 

end

