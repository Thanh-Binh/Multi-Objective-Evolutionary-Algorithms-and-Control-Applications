function [fig,txthndl]=diagscrl(cmd,data,name,marks,twocolumn)
% [fig,txthndl]=diagscrl(cmd,data,name,marks,twocolumn)
%
% Create a scrollable window with both vertical and horizontal slide bar 
% to display a numerical matrix with any number of columns and rows
%
% To display a text in the scrollable window please use the function
% TWSCROLL.M
%
% Inputs:
%    cmd - is one of the following command strings:
%          cmd='init'   to initialize a creating a scrollable window.
%                       In this case the second input is required to
%                       get data and put them on the screen.
%
%          cmd='yslide' to scroll the window vertically.
%
%          cmd='xslide' to scroll the window horizontally.
%
%          Notice: Users can only use directly the command string 'init',
%                  and the three last command strings are not intended to
%                  be called directly by users.
%
%    data - the numerical matrix to be displayed on the screen.
%           Dimension of data: nrows and ncols
%
%
%          Nr.   Objfun1  Objfun2 .....  ObjfunN           Nr.      Objfun1   Objfun2 .....
%          1     31232    43435           5345345          nrows/2+1  445645   54343  ....
%          2     545654   645654          654              nrows/2+2    645     343  ....
%          .    ...................................         ..............................
%     nrows/2     4324     4234            6566756         nrow         32342   54344 ...
% 
%
%    name - The string described the name of the scrollable window
%
%    marks - a matrix (2 x N) used to mark some elements of the data 
%           e.g.: for the 4-th column of marks we have tmp=marks(:,4); 
%           therefore we want to mark the element data(tmp(1),tmp(2)) of the matrix data
%           marks=[] means not mark
%
%    twocolumn = 1(0)   for displaying data in two (one) column
%     
%
% Usage:
%    data=rand(20,30);
%    diagscrl('init',data);
%    diagscrl('init',data,'My scrollable window')
%    diagscrl('init',data,'My scrollable window','Objfun')


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Evolution Strategy Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany

if nargin<1, 
   disp(' Required:')
   disp('    at least two inputs by the first starting')
   disp('    or one input argument in the other cases!');
   error(' For Help please type: help diagscrl on the matlab prompt.')
   return;
end

% Default Values for displaying text on axes:

SliderWidth=20;                     % the width of the scroll bar in pixels
FontSize=12;                        % Size of the font in pixels
FontName='Courier';


% Get a good font for buttons in this platform.
[fname,fsize] = bestfont(computer);
Std.Units='pixels';
Std.FontName=fname;
Std.FontSize=fsize;


if strcmp(cmd(1:4),'init'),
   if nargin <5,
      twocolumn=1;
      if nargin < 4,
         marks=[];
         if nargin <3,
            name='The Scroll Window';
            if nargin < 2,    
               errortxt=str2mat('Required at least two inputs by the first starting',...
                     'Usage: diagscrl(''init'',data_matrix)');
               esmsg(errortxt,'Error','error');
               return;
            end
         end
      end
   end
   if isstr(data),
      esmsg('Please use twscroll.m to display a text!','Error','error')
      return; 
   end
   if ~isstr(name),
      esmsg('Please see help for diagscrl.m','Error','error')
      return;
   end
   [nA,mA]=size(data);

   OldFig=findobj('name','Dialog to the obtained Pareto-Set');
   coln='Objfun'; 
   lengthcoln=length(coln);
   if isempty(OldFig), 

      ScrUnit=get(0,'Units'); set(0,'Units','pixels');
      ScrPos=get(0,'ScreenSize'); set(0,'Units',ScrUnit);
      if ScrPos(3:4)~=[640 480],
         myheight=640;mywidth=900;
      else
         myheight=450;mywidth=600;
      end
      fig_pos=[.5*(ScrPos(3)-mywidth) .5*(ScrPos(4)-myheight) mywidth myheight];
           
      fig=figure('Units','pixels','name',name,'numbertitle','off','menubar','none',...
              'nextplot','add','tag','diagscrl-main','pos',fig_pos,'Resize','on',...
              'InvertHardcopy','off','BackingStore','off',...
              'WindowButtonMotionFcn','dghelper;',...
              'Visible','off','Color',[1 1 1],...
              'DefaultTextHorizontalAlignment','left', ...
              'DefaultTextVerticalAlignment','bottom', ...
              'DefaultTextClipping','on');

                                % Check to know the values of pLineHeight and pColsWidth 
                                % for each system
      htest=text('FontName',FontName,'FontSize',FontSize,...
                 'pos',[0 0],'String','T','Units','pixels');    
      siz=textent(htest); 
      pLineHeight=1.5*siz(4);      % Distance between lines
      wch = siz(3);                % Width of a single character in pixels.
      fw = 8;                      % Column width.  Each column can have up to 
                                   % 8-digits in it.
      fd = 4;                      % there are 4 blank character between columns

      wc = fw*wch;                 % Width of 8 digit column in pixels
      dwc = fd*wch;                % Distance between columns in pixels (width of 4 digits)
      pColsWidth=wc+dwc;           % Step used for columns in pixels
      delete(htest);

      HeadBarHeight=30;            % height of the bar for the figure head
      StatusHeight=30;             % height of the bar to display the help texts
      ConsolWidth =150;            % width of the consul frame
      Frame2Axes=0;               % Distance from Frame to Axes


      nlineperscreen=floor((fig_pos(4)-SliderWidth-HeadBarHeight-StatusHeight)/pLineHeight);

      links=pLineHeight;           % Distance between lines in the YLim (in the Data space) 
                                   % e.g.  
                                   % if   text(x,y,'The i-th line') to display the i-th line, 
                                   % then text(x,y+links,'The (i+1)-th line') for the next line 
      ylim=links*nlineperscreen;
 

      ncolsperscreen=floor((fig_pos(3)-SliderWidth-ConsolWidth)/pColsWidth);  

      xlinks=pColsWidth;           % Distance between columns in the XLim (in the Data space) 
                                   % e.g.  
                                   % if   text(x,y,'The i-th column') to display the i-th column, 
                                   % then text(x+xlinks,y,'The (i+1)-th column') for the next column 
      xlim=xlinks*ncolsperscreen;
   
                                   % make the position of figure correctly

      myheight=ylim+SliderWidth+HeadBarHeight+StatusHeight+2;
      mywidth =xlim+SliderWidth+ConsolWidth+2*Frame2Axes;
      fig_pos=[.5*(ScrPos(3)-mywidth) .5*(ScrPos(4)-myheight) mywidth myheight];
  
      set(gcf,'pos',fig_pos);
    
      % create an axes so that a help text can be displayed on it 
      postmp=[1 0 fig_pos(3)-2 StatusHeight];
      HelpAxes=axes('unit','pixels','pos',postmp,'Color',[.4 .8 .8],...
        'Xtick',[],'Ytick',[],'XGrid','off','YGrid','off');
      text('Parent',HelpAxes,'unit','norm','pos',[.5 .25],...
        'String','Welcome to the dialog with the pareto-optimal set',...
        'Color','b','tag','diagscrl-HelpText','HorizontalAlignment','center');


      postmp=[fig_pos(3)-SliderWidth-ConsolWidth SliderWidth+StatusHeight SliderWidth ylim+2];
      h(1)=uicontrol('style','slider','unit','pixels','pos',postmp,'value',1,...
        'Back',[.8 .8 .8],'tag','diagscrl-vertsld','call','diagscrl(''yslide'')');

      h(2)=uicontrol('style','slider','unit','pixels','value',0,...
        'pos',[1 StatusHeight xlim+2*Frame2Axes  SliderWidth],...
        'Back',[.8 .8 .8],'tag','diagscrl-horzsld','callback','diagscrl(''xslide'')');
   
      postmp=[fig_pos(3)-SliderWidth-ConsolWidth  StatusHeight SliderWidth SliderWidth];
      h(3)=uicontrol('Style','frame','unit','pixels','pos',postmp,...
        'Back',[.7 .7 .7],'tag','diagscrl-frame');

      % create the frame for headbar and some push buttons on it

      postmp=[1 fig_pos(4)-HeadBarHeight xlim+2*Frame2Axes+SliderWidth HeadBarHeight];
      uicontrol('style','frame','unit','pixels','pos',postmp,'Back',[.4 .8 .8],...
        'tag','diagscrl-Headframe');

      uicontrol(Std,'style','push','pos',[postmp(1)+5 postmp(2)+5 120 HeadBarHeight-10],...
        'String','Graphical Display','tag','diagscrl-Graphic','Call','esdialog(''paretdsp'');');

      uicontrol(Std,'style','push','pos',[postmp(3)-185 postmp(2)+5 50 HeadBarHeight-10],...
        'String','Reload','tag','diagscrl-Reload','Callback',[...
        'Par=get(findobj(''tag'',''diagscrl-Reload''),''UserData'');',...
        'if isnumeric(Par)|isstr(Par),',...
        '   esdialog(''init'',Par);',...
        'else,',...
        '   error(''Data can not be loaded!'');',...
        'end;']);

      uicontrol(Std,'style','push','pos',[postmp(3)-120 postmp(2)+5 50 HeadBarHeight-10],...
        'String','Close','tag','diagscrl-Close','Callback','close(gcf)');

      uicontrol(Std,'style','push','pos',[postmp(3)-55 postmp(2)+5 50 HeadBarHeight-10],...
        'String','Help','tag','diagscrl-Help','Callback','esdialog(''Help'');');

      % create the consol frame and some push buttons on it
      postmp=[fig_pos(3)-ConsolWidth StatusHeight ConsolWidth fig_pos(4)-StatusHeight];
      uicontrol('style','frame','unit','pixels','pos',postmp,'Back',[.4 .8 .8],...
        'tag','diagscrl-Consolframe');
      ButtonHeight=22;

      postmp=[postmp(1)+15 fig_pos(4)-10*ButtonHeight-10 ConsolWidth-30 9*ButtonHeight+6];
      uicontrol('style','frame','unit','pixels','pos',postmp,'tag','diagscrl-Optionframe');

      uicontrol(Std,'style','push','pos',[postmp(1)+2 postmp(2)+2 postmp(3)-4 ButtonHeight],...
        'String','Germeier','tag','diagscrl-Germeier','Call','esdialog(''germeier'');');

      uicontrol(Std,'style','push','String','Epsilon',...
        'pos',[postmp(1)+2 postmp(2)+2+ButtonHeight postmp(3)-4 ButtonHeight],...
        'tag','diagscrl-Epxilon','Call','esdialog(''epsilon'');');

      uicontrol(Std,'style','push','String','Goal',...
        'pos',[postmp(1)+2 postmp(2)+2+2*ButtonHeight postmp(3)-4 ButtonHeight],...
        'tag','diagscrl-Goal','Call','esdialog(''goal'');');

      uicontrol(Std,'style','push','String','Lp-norm',...
        'pos',[postmp(1)+2 postmp(2)+2+3*ButtonHeight postmp(3)-4 ButtonHeight],...
        'tag','diagscrl-Lpnorm','Call','esdialog(''lpnorm'');');

      uicontrol(Std,'style','push','String','Weighting',...
        'pos',[postmp(1)+2 postmp(2)+2+4*ButtonHeight postmp(3)-4 ButtonHeight],...
        'tag','diagscrl-Weighting','Call','esdialog(''weighting'');');

      uicontrol(Std,'style','push','String','Minimax2',...
        'pos',[postmp(1)+2 postmp(2)+2+5*ButtonHeight postmp(3)-4 ButtonHeight],...
        'tag','diagscrl-Minimax2','Call','esdialog(''minimax2'');');

      uicontrol(Std,'style','push','String','Minimax1',...
        'pos',[postmp(1)+2 postmp(2)+2+6*ButtonHeight postmp(3)-4 ButtonHeight],...
        'tag','diagscrl-Minimax1','Call','esdialog(''minimax1'');');

      uicontrol(Std,'style','push','String','Number',...
        'pos',[postmp(1)+2 postmp(2)+2+7*ButtonHeight postmp(3)-4 ButtonHeight],...
        'tag','diagscrl-Number','Call','esdialog(''number'');');

      uicontrol(Std,'style','text',...
        'pos',[postmp(1)+2 postmp(2)+4+8*ButtonHeight postmp(3)-4 ButtonHeight],...
        'String','Method Options','tag','diagscrl-OptionText','Fore','b');


      postmp=[fig_pos(3)-ConsolWidth+15 fig_pos(4)-18*ButtonHeight ConsolWidth-30 3*ButtonHeight+6];
      uicontrol('style','frame','unit','pixels','pos',postmp,'tag','diagscrl-Elimframe');

      uicontrol(Std,'style','push','pos',[postmp(1)+2 postmp(2)+2 postmp(3)-4 ButtonHeight],...
         'String','Undo','tag','diagscrl-Comeback','Call','esdialog(''back'');');

      uicontrol(Std,'style','push',...
         'pos',[postmp(1)+2 postmp(2)+2+ButtonHeight postmp(3)-4 ButtonHeight],...
         'String','Do','tag','diagscrl-Elimin','Call','esdialog(''another'');');

      uicontrol(Std,'style','text',...
         'pos',[postmp(1)+2 postmp(2)+4+2*ButtonHeight postmp(3)-4 ButtonHeight],...
         'String','Elimination','tag','diagscrl-ElimText','Fore','b');

      aud={100 nlineperscreen  links 0 0 0 0;...
          100  ncolsperscreen  xlinks 0 0 0 0;...
          fig_pos(1) fig_pos(2) fig_pos(3) fig_pos(4) h(1) h(2) h(3);...
          fw fd wch wc dwc xlim ylim};
      
      axes('units','pixel','pos',[Frame2Axes SliderWidth+StatusHeight xlim+Frame2Axes ylim+2],...
        'xlim',[0 xlim],'ylim',[0 ylim],'tag','diagscrl-axes',...
        'Xtick',[],'Ytick',[],'XGrid','off','YGrid','off','TickLength',[0 0],...
        'XColor','w','YColor','w',...
        'ydir','reverse','clipping','on','visible','on','nextplot','add');  %

   else,
      % Check if the new data is identical to the old data. If true, do not redisplay data 
      OldData=get(findobj('tag','diagscrl-Headframe'),'UserData');
      fig=OldFig;
      if all(size(OldData{1})==size(data)),
         if ~(any(any(OldData{1}~=data))), 
            txthndl=OldData{2};return,
         end
      end
      delete(OldData{2});
      aud=get(findobj('Tag','diagscrl-axes'),'UserData');
      links=aud{1,3};xlinks=aud{2,3};xlim=aud{4,6};ylim=aud{4,7};
      fw=aud{4,1};fd=aud{4,2};wch=aud{4,3};wc=aud{4,4};dwc=aud{4,5};
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % From here the matrix of the data can be displayed on the screen
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   nA1=ceil(nA/2);nA2=nA-nA1; 
   totlines=nA1+2;            % the total number of lines in the axes                      
   if twocolumn,
      totcols=2*mA+1;            % the total number of columns in the axes
   else,
      totcols=mA+1;            % the total number of columns in the axes
   end

   aud{1,1} = totlines; aud{2,1}=totcols;
   MainAxes=findobj('Tag','diagscrl-axes');
   set(MainAxes,'UserData',aud);
 
   txt_tmp=['Nr.' 32*ones(1,fw-7) 'Distance' 32*ones(1,fd)];
   for i=2:mA,                %In the first line write: Nr  Column1   Column2 .... Nr Column1
      if i<10,
         txt_tmp=[txt_tmp 32*ones(1,fw-lengthcoln -1) coln int2str(i-1) 32*ones(1,fd)];
      elseif (i>=10)&(i<100)
         txt_tmp=[txt_tmp 32*ones(1,fw-lengthcoln -2) coln int2str(i-1) 32*ones(1,fd)];
      elseif (i>=100)&(i<1000)
         txt_tmp=[txt_tmp 32*ones(1,fw-lengthcoln -3) coln int2str(i-1) 32*ones(1,fd)];
      end 
   end
   if twocolumn,
      txt_tmp=[txt_tmp 32*ones(1,fw+1) txt_tmp];
      if (2*mA*xlinks+(fd+fw)*wch) <= xlim,
         set(aud{3,6},'Enable','Inactive'); 
      end
      if (nA1*links) < ylim,
         set(aud{3,5},'Enable','Inactive'); 
      end
   else,
      nA1=nA;
      if (mA*xlinks) <= xlim,
         set(aud{3,6},'Enable','Inactive'); 
      end
      if (nA*links) < ylim,
         set(aud{3,5},'Enable','Inactive'); 
      end
   end
   text('Parent',MainAxes,'FontName',FontName,'FontSize',FontSize,...
        'pos',[0,links],'String',txt_tmp,'color','blue');

   for i=1:nA1,                % Rows
                               % describe the numberization of rows for the 1-st main column
      text('Parent',MainAxes,'FontName',FontName,'FontSize',FontSize,...
           'pos',[0,(i+2)*links],'String',int2str(i),'color','blue');
      txt_tmp=[32*ones(1,fd)];
      for j=1:mA,              % Columns
         tmp1=sprintf('%3.4f',data(i,j));
         lengthtmp=length(tmp1);
         if lengthtmp>fw,      % if data(i,j) is too big, then display only the 8 first digits 
            lengthtmp=fw;
            tmp1=tmp1(1:fw);
         end  
         txt_tmp=[txt_tmp  32*ones(1,fw-lengthtmp) tmp1 32*ones(1,fd)];
      end
      txthndl(i)=text('Parent',MainAxes,'FontName',FontName,'FontSize',FontSize,...
         'pos',[0,(i+2)*links],'String',txt_tmp);  
   end

   for i=nA1+1:nA,             % Rows
                               % describe the numberization of rows for the 2-nd main column
      text('Parent',MainAxes,'FontName',FontName,'FontSize',FontSize,...
           'pos',[mA*xlinks+(fd+fw)*wch,(i-nA1+2)*links],...
           'String',int2str(i),'color','blue');
      txt_tmp=[32*ones(1,fd)];  
      for j=1:mA,              % Columns
         tmp1=sprintf('%3.4f',data(i,j));
         lengthtmp=length(tmp1);
         if lengthtmp>fw,      % if data(i,j) is too big, then display only the 8 first digits 
            lengthtmp=fw;
            tmp1=tmp1(1:fw);
         end  
         txt_tmp=[txt_tmp  32*ones(1,fw-lengthtmp) tmp1 32*ones(1,fd)];
      end 
      txthndl(i)=text('Parent',MainAxes,'FontName',FontName,'FontSize',FontSize,...
         'pos',[mA*xlinks+(fd+fw)*wch,(i-nA1+2)*links],'String',txt_tmp); 
   end

   if ~isempty(marks),        % make some markes 
      for i=1:length(marks(1,:)),
         tmp=marks(:,i);
         tmp1=sprintf('%3.4f',data(tmp(1),tmp(2)));
         lengthtmp=length(tmp1);
         if lengthtmp>fw,     % if data(tmp(1),tmp(2)) is too big, then display only the 8 first digits 
            lengthtmp=fw;
            tmp1=tmp1(1:fw);
         end  
         if tmp(1) <= nA1,
            line([tmp(2)*xlinks, tmp(2)*xlinks-lengthtmp*wch],[(tmp(1)+2)*links,(tmp(1)+2)*links],'color','red');
         else,
            line(mA*xlinks+(fd+fw)*wch+[tmp(2)*xlinks, tmp(2)*xlinks-lengthtmp*wch],...
                [(tmp(1)-nA1+2)*links,(tmp(1)-nA1+2)*links],'color','red');               
         end
      end
   end     

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % End display the matrix on the screen
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                       
   set(findobj('tag','diagscrl-Headframe'),'UserData',{data,txthndl});
   set(fig,'Visible','on');


elseif strcmp(cmd,'yslide'),                    

      axes_fig=findobj(gcf,'tag','diagscrl-axes');
      if isempty(axes_fig)
           error('Cannot scroll: No Scroll Window available.');
           return;
      end
      aud=get(axes_fig,'userdata');
      % aud(1,:)=[totlines nlineperscreen links 0 0];

      ylim=get(axes_fig,'ylim');
      if diff(ylim) > aud{1,1}*aud{1,3},
      % It all fits.  Stop worrying.
            ylim=ylim-ylim(1);
      end

      vsldval=get(aud{3,5},'value');    
      
      pos=aud{1,2}*aud{1,3}+round((1-vsldval)*(aud{1,1}-aud{1,2}))*aud{1,3}; 
      ylim=[pos-diff(ylim) pos];
      if ylim(1)<0, ylim=[0,diff(ylim)];end
      set(axes_fig,'ylim',ylim);                


elseif strcmp(cmd,'xslide'),   

      axes_fig=findobj(gcf,'tag','diagscrl-axes');
      if isempty(axes_fig)
           error('Cannot scroll: No Scroll Window available.');
           return;
      end
      aud=get(axes_fig,'userdata');              
      % aud(2,:)=[maxxpos totcols ncolsperscreen pColsWidth xlinks 0 0];

      xlim=get(axes_fig,'xlim');
      if diff(xlim) > aud{2,1}*aud{2,3},
      % It all fits.  Stop worrying.
            xlim=xlim-xlim(1);
      end
         
      hsldval=get(aud{3,6},'value');    
      
      pos=aud{2,2}*aud{2,3}+round(hsldval*(aud{2,1}-aud{2,2}))*aud{2,3}; 
      xlim=[pos-diff(xlim) pos];
      if xlim(1)<0, xlim=[0,diff(xlim)];end
      set(axes_fig,'xlim',xlim);    

else

     error(' Please type: help diagscrl for more informations ');
     return;
end
