function ssp_get(action,Par1,Par2)
% ssp_get(action,Par1,Par2)
% Get the parameters (A,B,C,D,E) of the Model in the State Space
% then save them in a mat-file, the name of which can be inputed
% from users, or save them in the 'planttmp.mat' for using in the
% design process.
%
% This function is not intended to call directly from users.
%
% See also DESIGN.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


if nargin<1,
    action='init';
end;

% Get a good font for this platform.
[fname,fsize] = bestfont(computer);
Std.Units='norm';
Std.FontName=fname;
Std.FontSize=fsize;

switch action,
   case 'init',
      mainfig=findobj('tag','DesignMainFig');
      mainfig_pos=get(mainfig,'pos'); 
      CtrlHndl=findobj('tag','DesignCtrlType');
      set(CtrlHndl,'Enable','on');

      figure('units','pixels','Name','Set the Nominal Plant','pos',mainfig_pos,...
        'NumberTitle','off','MenuBar','none','Color','b',...
        'Visible','off','tag','SSP_GetMatrix');
      xspace =.02;xspace1=.004;FrameHeight=.07;
      aheight=.5;cheight=.35;
      aypos  =FrameHeight+cheight+3.5*xspace;cypos=FrameHeight+8*xspace;
      awidth=.42;bwidth=.25;ewidth=.25;

      uicontrol(Std,'Style','text','Pos',[xspace FrameHeight+xspace .5*awidth .05],...
        'String','Steady state values:','HorizontalAlignment','left',...
        'back','b','fore','y');
      uicontrol(Std,'Style','text','Pos',[xspace FrameHeight+xspace+.06 .5*awidth .05],...
        'string','Desired Outputs:','HorizontalAlignment','left',...
        'back','b','fore','y');

      output=uicontrol(Std,'Style','edit','fore','b','string','[]',...
        'Pos',[xspace+.5*awidth FrameHeight+xspace+.07 bwidth+.23 .065]);
      ssval=uicontrol(Std,'Style','edit','fore','b','string','[]',...
        'Pos',[xspace+.5*awidth FrameHeight+xspace bwidth+.23 .065]);

      uicontrol('Style','frame','Units','norm','Pos',[.001 0 .998 .08]);
      uicontrol(Std,'Style','push','String','Load Plant','Pos',[.04 .01 .2 .06],...
        'call','ssp_get(''load'');');
      uicontrol(Std,'Style','push','String','Save Plant','Pos',[.28 .01 .2 .06],...
        'call','ssp_get(''save'',1);');
      uicontrol(Std,'Style','push','String','Close','Pos',[.52 .01 .2 .06],...
        'call','pl=get(gcf,''UserData'');set(pl(6),''Visible'',''on'');close(gcf)');
      uicontrol(Std,'Style','push','String','OK','Pos',[.76 .01 .2 .06],...
        'call','pl=get(gcf,''UserData'');ssp_get(''save'',0);set(pl(6),''Visible'',''on'')');

      % Set up the A matrix Window
      uicontrol('Style','frame','Units','norm',...
        'Pos',[xspace aypos awidth aheight],'Back',[.4 .8 .8]);
      uicontrol(Std,'Style','push',...
        'Pos',[xspace+xspace1 aypos+aheight-.065 awidth-1.8*xspace1 .06], ...
        'Back','b','Fore','y','String','Matrix A','call',[...
        'ssp_get(''augment'',''Matrix A'',findobj(''tag'',''AHndl''));']);

      % Then the editable text field
      AHndl=uicontrol(Std,'Style','edit','Max',20,'Back','w', ...
        'FontName','Courier','FontSize',12,'HorizontalAlignment','left',...
        'Pos',[xspace+xspace1 aypos+xspace1 awidth-2*xspace1 aheight-2*xspace1-.065], ...
        'String','[ ]','UserData',0,'tag','AHndl','call','ssp_get(''SetPar'',1);');

      % Set up the B matrix Window
      uicontrol('Style','frame','Units','norm',...
        'Pos',[2*xspace+awidth aypos bwidth aheight],'Back',[.4 .8 .8]);
      uicontrol(Std,'Style','push',...
        'Pos',[2*xspace+awidth+xspace1 aypos+aheight-.065 bwidth-1.8*xspace1 .06], ...
        'Back','b','Fore','y','String','Matrix B','call',[...
        'ssp_get(''augment'',''Matrix B'',findobj(''tag'',''BHndl''));']);

      % Then the editable text field
      BHndl=uicontrol(Std,'Style','edit','Max',20,'Back','w', ...
        'FontName','Courier','FontSize',12,'HorizontalAlignment','left',...
        'Pos',[2*xspace+awidth+xspace1 aypos+xspace1 bwidth-2*xspace1 aheight-2*xspace1-.065], ...
        'String','[ ]','UserData',0,'tag','BHndl','call','ssp_get(''SetPar'',2);');


      % Set up the E matrix Window
      if ewidth~=0,
         uicontrol('Style','frame','Units','norm',...
           'Pos',[3*xspace+awidth+bwidth aypos ewidth aheight],'Back',[.4 .8 .8]);
         uicontrol(Std,'Style','push',...
           'Pos',[3*xspace+awidth+bwidth+xspace1 aypos+aheight-.065 ewidth-2*xspace1 .06], ...
           'Back','b','Fore','y','String','Matrix E','call',[...
           'ssp_get(''augment'',''Matrix E'',findobj(''tag'',''EHndl''));']);
         % Then the editable text field
         EHndl=uicontrol(Std,'Style','edit','Max',20,'Back','w', ...
           'FontName','Courier','FontSize',12,'HorizontalAlignment','left',...
           'Pos',[3*xspace+awidth+bwidth+xspace1 aypos+xspace1 ewidth-2*xspace1 aheight-2*xspace1-.065], ...
           'String','[ ]','UserData',0,'tag','EHndl','call','ssp_get(''SetPar'',5);');
      end

      cheight=.25;

      % Set up the C matrix Window
      uicontrol('Style','frame','Units','norm',...
         'Pos',[xspace cypos awidth cheight],'Back',[.4 .8 .8]);
      uicontrol(Std,'Style','push',...
        'Pos',[xspace+xspace1 cypos+cheight-.065 awidth-1.8*xspace1 .06], ...
        'Back','b','Fore','y','String','Matrix C','call',[...
        'ssp_get(''augment'',''Matrix C'',findobj(''tag'',''CHndl''));']);
      % Then the editable text field
      CHndl=uicontrol(Std,'Style','edit','Max',20,'Back','w', ...
        'FontName','Courier','FontSize',12,'HorizontalAlignment','left',...
        'Pos',[xspace+xspace1 cypos+xspace1 awidth-2*xspace1 cheight-2*xspace1-.065], ...
        'String','[ ]','UserData',0,'tag','CHndl','call','ssp_get(''SetPar'',3);');

      % Set up the D matrix Window
      uicontrol('Style','frame','Units','norm',...
         'Pos',[2*xspace+awidth cypos bwidth cheight],'Back',[.4 .8 .8]);
      uicontrol(Std,'Style','push',...
        'Pos',[2*xspace+awidth+xspace1 cypos+cheight-.065 bwidth-1.8*xspace1 .06], ...
        'Back','b','Fore','y','String','Matrix D','call',[...
        'ssp_get(''augment'',''Matrix D'',findobj(''tag'',''DHndl''));']);
      % Then the editable text field
      DHndl=uicontrol(Std,'Style','edit','Max',20,'Back','w', ...
        'FontName','Courier','FontSize',12,'HorizontalAlignment','left',...
        'Pos',[2*xspace+awidth+xspace1 cypos+xspace1 bwidth-2*xspace1 cheight-2*xspace1-.065], ...
        'String','[ ]','UserData',0,'tag','DHndl','call','ssp_get(''SetPar'',4);');
      axes('Units','norm','XTick',[],'YTick',[],'Box','on',...
        'Color','b','Pos',[3*xspace+awidth+bwidth .18 ewidth .2]);
      if strncmp(computer,'PC',2),
        ThisFontSize=10;
        ThisText=str2mat('dx/dt = Ax+Bu+En','       y = Cx+Du');
      else,
        ThisFontSize=10;
        ThisText=str2mat('dx/dt=Ax+Bu+En','      y=Cx+Du');
      end       
      text('Units','norm','pos',[.08,.5],'string',ThisText,'FontSize',ThisFontSize,...
        'FontWeight','bold','Color','y','HorizontalAlignment','left');
      set(gcf,'Visible','on','UserData',...
        [AHndl BHndl CHndl DHndl EHndl mainfig output ssval CtrlHndl]);


  case 'SetPar',
      fud=get(gcf,'UserData');
      mattmp=eval(get(fud(Par1),'String'));
      set(fud(Par1),'string',matostr(mattmp));


  case 'augment',
      fig=findobj('tag','DesignGetMatrix');
      if ~isempty(fig),
         pl=get(fig,'UserData');
         if ~strcmp(get(fig,'name'),Par1),
            set(fig,'name',Par1);
            set(pl(2),'string',get(Par2,'string'));
         end
         set(fig,'Visible','on','UserData',[Par2 pl(2)]);figure(fig);
      else,
         mainfig=findobj('tag','DesignMainFig');
         mainfig_pos=get(mainfig,'pos');
         fig=figure('Name',Par1,'units','pixels','pos',mainfig_pos,'tag','DesignGetMatrix', ...
           'NumberTitle','off','MenuBar','none','Color','w');
         tmphndl=uicontrol(Std,'style','edit','pos',[.001 .11 .998 .889],...
           'max',10,'string',get(Par2,'string'));
         uicontrol('style','frame','pos',[.01 .01 .98 .09],'units','norm','back','b');
         uicontrol(Std,'style','push','pos',[.45 .03 .1 .05],...
           'String','OK','call',[...
           'pl=get(gcf,''Userdata'');',...
           'set(pl(1),''string'',get(pl(2),''string''));set(gcf,''Visible'',''off'')']);
         set(fig,'UserData',[Par2 tmphndl]);
      end
    

  case 'load',
     hndlList=get(gcf,'UserData');
     [newfile, newpath] = uigetfile('*.mat', 'Load Nominal Plant');
     if(newfile),
        fileStr=[newpath,newfile];
        load(fileStr); msgtxt=[];
        if(exist('a')~=1), msgtxt=[msgtxt;['Error in file ',fileStr,' with matrix A']];end
        if(exist('b')~=1), msgtxt=[msgtxt;['Error in file ',fileStr,' with matrix B']];end
        if(exist('c')~=1), msgtxt=[msgtxt;['Error in file ',fileStr,' with matrix C']];end
        if(exist('d')~=1), msgtxt=[msgtxt;['Error in file ',fileStr,' with matrix D']];end

        if ~isempty(msgtxt), 
           esmsg(msgtxt,'Error','error');
        else,
           if hndlList(5),
              if (~exist('e','var')) | isempty(e) , 
                 set(hndlList(5),'String','[ ]');
              else
                 set(hndlList(5),'String',matostr(e));
              end
           end
           set(hndlList(1),'String',matostr(a));
           set(hndlList(2),'String',matostr(b));
           set(hndlList(3),'String',matostr(c));
           set(hndlList(4),'String',matostr(d));
           if exist('output','var'), 
              set(hndlList(7),'String',mat2str(output));
           else,
              set(hndlList(7),'String',mat2str([1:size(c,1)]));
           end
           if exist('ssval','var'), 
              set(hndlList(8),'String',mat2str(ssval));
           else,
              set(hndlList(8),'String',mat2str(ones(1,size(c,1))));
           end
        end
     end            



  case 'save',  
     hndlList=get(gcf,'UserData');
     a=str2num(get(hndlList(1),'String'));
     b=str2num(get(hndlList(2),'String'));
     c=str2num(get(hndlList(3),'String'));
     d=str2num(get(hndlList(4),'String'));
     errorflag=0;
     [n,ma]=size(a);[n,mb]=size(b);[p,mc]=size(c);
     if rem(ma,n),
        errorflag =1;
     else
        mmodel=ma/n;
        if rem(mb,mmodel)|rem(mc,mmodel),
           errorflag =1;
        else,
           if hndlList(5),
              e=str2num(get(hndlList(5),'String'));
              [ne,me]=size(e);
              if rem(me,mmodel), errorflag=1;end
           else,
              e=[];me=0;
           end
        end
     end
     if ~errorflag,
        m=mb/mmodel;me=me/mmodel;
        if hndlList(5),
           error=abcdechk(a(:,1:n),b(:,1:m),c(:,1:n),d(:,1:m),e(:,1:me));
        else,
           error=abcdechk(a(:,1:n),b(:,1:m),c(:,1:n),d(:,1:m));
        end
        if ~isempty(error),errorflag=1;end
        output=str2num(get(hndlList(7),'String'));
        output_num=length(output);
        if output_num,
           if output_num > p,
              errorflag=1;
              error1=' Please choose the desired outputs again!';
           else,
              ssval=str2num(get(hndlList(8),'String'));
              if length(output)~=length(ssval),
                 errorflag=1;
                 error1=str2mat(' Output vector and vector of steady state values',...
                       ' must have the same length!');
              end
           end
        end
 
        if errorflag,
           error=str2mat(error,error1);
           esmsg(error,'Error','error');
        else
           if ~output_num, 
              output=[1:p];ssval=ones(1,p);
           else,
              [output,index]=sort(output);ssval=ssval(index);
           end
           mpar=[mmodel,n,m,p,me];
           if Par1,
              [newfile, newpath] = uiputfile('*.mat', 'Save Nominal Plant');
              if(newfile),
                 save([newpath,newfile],'a','b','c','d','e','output','ssval','mpar');
              end
           else,
              save('planttmp.mat','a','b','c','d','e','output','ssval','mpar');
              Plant.a=a; Plant.b=b;Plant.c=c;Plant.d=d;Plant.e=e; Plant.dim=mpar;
              Plant.output=output;Plant.ssval=ssval;
              set(findobj('tag','DesignPlant'),'UserData',Plant); 
              
              % set default values for performances 
              PerfType{1}=[NaN,[1:m]]'; PerfType{8}=NaN;
              for i=2:7,PerfType{i}= [NaN,[1:p]]'; end;             
              set(findobj('tag','DesignPerform'),'UserData',PerfType);               
              close(gcf);
           end
        end
     else
        esmsg('Incompatible dimension','Error','error');      
     end   

end
