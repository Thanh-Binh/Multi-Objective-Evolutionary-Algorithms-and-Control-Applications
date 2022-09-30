function eshlpmk(action);
%BHLPMK An Evolution help-making utility.

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize'),
    set(0,'Units','Pixels'); ss=get(0,'ScreenSize');
    mywidth=560;myheight=460;
    mybottom = .5*(ss(4)-myheight);
    myleft = .5*(ss(3)-mywidth);
    position=[myleft mybottom mywidth myheight];

    figNumber=figure( ...
        'Name','Help Maker for the Evolution Strategy', ...
        'NumberTitle','off', ...
        'Menubar','none',...
        'NextPlot','new', ...
	'Visible','off', ...
	'Position',position,'keypressfcn','uihelper', ...
	'Color',[.5 0 0],'Resize','off'); 

    %===================================
    % Set up the Comment Window
    top=0.97;
    left=0.03;
    right=0.77;
    bottom=0.03;
    labelHt=0.03;
    spacing=0.005;
    % First, the MiniCommand Window frame
    frmBorder=0.02;
    frmPos=[left-frmBorder bottom-frmBorder ...
	(right-left)+2*frmBorder (top-bottom)+2*frmBorder];
    uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.4 0.8 0.8]);
    % Then the text label
    labelPos=[left top-labelHt+.01 (right-left) labelHt];
    uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'BackgroundColor',[0.4 0.8 0.8], ...
	'ForegroundColor',[1 1 1], ...
        'String','Help Window');
    % Then the editable text field
    txtPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    txtHndl=uicontrol( ...
	'Style','edit', ...
        'Units','normalized', ...
        'Max',10, ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos);
    % Save this handle for future use
    set(gcf,'UserData',txtHndl);

    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    yInitPos=0.80;
    top=0.97;
    left=0.82;
    btnWid=0.15;
    btnHt=0.08;
    % Spacing between the button and the next command's label
    spacing=0.05;
    
    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=bottom-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder top-bottom+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.40 0.8 0.8]);

    %====================================
    % The QUOTE button
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Quote';
    callbackStr='eshlpmk(''quote'');';

    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    quoteHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Interruptible','yes', ...
        'Callback',callbackStr);

    %====================================
    % The UNQUOTE button
    btnNumber=2;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Unquote';
    callbackStr='eshlpmk(''unquote'');';

    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    unquoteHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Interruptible','yes', ...
        'Callback',callbackStr);

    %====================================
    % The CLEAR button
    btnNumber=3;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Clear';
    callbackStr='eshlpmk(''clear'')';

    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    clearHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Interruptible','yes', ...
        'Callback',callbackStr);

    %====================================
    % The HELP button
    labelStr='Help';
    callbackStr='eshlpmk(''help'')';
    helpHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left bottom+btnHt+spacing btnWid btnHt], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    %====================================
    % The CLOSE button
    labelStr='Close';
    callbackStr='close(gcf)';
    closeHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left bottom btnWid btnHt], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    hndlList=[txtHndl quoteHndl unquoteHndl helpHndl closeHndl];
    set(figNumber, ...
	'Visible','on', ...
	'UserData',hndlList);

elseif strcmp(action,'quote'),
    hndlList=get(gcf,'Userdata');
    txtHndl=hndlList(1);
    str=get(txtHndl,'String');
    % Replace all zeros with 32s (ASCII spaces) to avoid problems.
    str(find(abs(str)==0))=32*ones(size(find(abs(str)==0)));
    [numRows,numCols]=size(str);
    spaces=32*ones(numRows,8);
    quotes=setstr(39*ones(numRows,1));
    openBrace=['['; setstr(32*ones(numRows-1,1))];
    closeBrace=[setstr(32*ones(numRows-1,2)); '];'];
    if numCols<27,
       strNew=[spaces openBrace quotes str 32*ones(numRows,27-numCols) quotes closeBrace];
    else
       strNew=[spaces openBrace quotes str quotes closeBrace];
    end
    strNew=str2mat('    hlpStr= ...',strNew,'    bhlpfun(hlpname,titleStr,helpStr);');
    set(txtHndl,'String',strNew);


elseif strcmp(action,'unquote'),
    hndlList=get(gcf,'Userdata');
    txtHndl=hndlList(1);
    str=get(txtHndl,'String');
    [numRows,numCols]=size(str);
    strNew=str(2:numRows-1,11:numCols-3);
    set(txtHndl,'String',strNew);

elseif strcmp(action,'clear'),
    hndlList=get(gcf,'Userdata');
    txtHndl=hndlList(1);
    set(txtHndl,'String','');

elseif strcmp(action,'help'),
    ttlStr='Help Maker Help';
    hlpStr= ...                                                        
        [' Use this window to make the help strings for             '  
         ' MATLAB Evolution Strategy windows.                       '  
         '                                                          '  
         ' Simply type the text in the Help Window, then            '  
         ' click on the "Quote" button. This puts quotes            '  
         ' around the text automatically so you can                 '  
         ' insert it directly into your m-file.                     '  
         '                                                          '  
         ' The "Unquote" button does just the opposite,             '  
         ' so you can re-edit text that has already been            '  
         ' quoted.                                                  '  
         '                                                          '  
         ' The "Clear" button clears all text in the edit           '  
         ' field.                                                   '  
         '                                                          '  
         ' File name: eshlpmk.m                                      '];
    bhlpfun('How To Make A Help',ttlStr,hlpStr);                                            

end;    % if strcmp(action, ...

