function [W,ii]=w1ui(action,ii,W,nn)
% [W,ii]=w1ui(action,ii,W,nn)
%	User Interface to define Weighting function W1 details 
%
%	W(:,1)= flags for weighting 	0 : poles/zeros
%					1 : polynomials
%	W(:,2)= number of integrators
%	W(:,3)= numerator order
%	W(:,4)= denominator order


% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 


ColorA='k';
ColorB='w';
ColorC=[0.7,0.3,0.3];
ColorD='b';

if nargin<1,action='init';end;
if nargin<2,ii=1;end
if nargin<3,W=zeros(ii,4);end

% Get a good font for this platform.
[fname,fsize] = bestfont(computer);
Std.Units='norm';
Std.FontName=fname;
Std.FontSize=fsize;


switch action,
   case 'initialise',
      if nargin<4,nn=1;end
      if(~length(ii)),ii=1;end
      if(~length(W)),W=zeros(nn,4);end

      W=[W;zeros(nn-size(W,1),4)];
      figNumber=figure('Name','Weighting Function W1',...
        'NumberTitle','off','MenuBar','none', ...
	'Color',ColorA','Visible','off');

      xscale=.75;yscale=.56;
      axes('Units','norm','XTick',[],'YTick',[],'XLim',[0,1],'YLim',[0,1],...
	'Box','on','Pos',[.01 .43 xscale yscale],...
        'XColor',ColorB,'YColor',ColorB,'Color',ColorC);

      %draw weighting matrix
      Wid=min(0.8,nn*0.15);xmid=0.5+0.01;
      wwid=min(0.8/nn,0.15)*xscale;
      wht=min(0.8/nn,0.15)*yscale;
      Wid2=Wid/2+0.02;
      if nn==1,
         text(xmid-Wid2-0.01,0.5,'W1 = ','HorizontalAlignment','right', ...
	     'Color',ColorB,'FontName',fname,'FontSize',fsize);
	 xPos=0.01+(xmid-Wid/2)*xscale;
         yPos=0.99-(0.5-Wid/2)*yscale-wht;
         btnPos=[xPos yPos wwid wht];
	 uicontrol(Std,'Style','push','Pos',btnPos,'Back',ColorB,...
	    'String','W1(11)','call','');

      else
    	 text(xmid-Wid2-0.01,0.5,'W1 = ','HorizontalAlignment','right',...
              'Color',ColorB,'FontName',fname,'FontSize',fsize);
         x=[xmid+0.01-Wid2,xmid-0.01+Wid2;xmid-Wid2,xmid+Wid2;
	    xmid-Wid2,xmid+Wid2;xmid+0.01-Wid2,xmid-0.01+Wid2;];
    	 y=[0.5-Wid2,0.5-Wid2;0.5-Wid2,0.5-Wid2;
	    0.5+Wid2,0.5+Wid2;0.5+Wid2,0.5+Wid2];
    	 line(x,y,'Color',ColorB)
	 for jj=1:nn,
	    xPos=0.01+(xmid-Wid/2)*xscale+(jj-1)*wwid;
	    yPos=0.99-(0.5-Wid/2)*yscale-jj*wht;
  	    labelStr=['W1(',num2str(jj),num2str(jj),')'];
    	    CallStr=['[W1,W1_ii]=w1ui(''element'',',num2str(jj),',W1);'];
	    btnPos=[xPos yPos wwid wht];
	    uicontrol(Std,'Style','push','Pos',btnPos,'Back',ColorB,...
	        'String',labelStr,'call',CallStr);
	 end
      end
      xscale=.98;

      %Define an element
      % The ELEMENT frame
      frmPos=[0.01 0.02 xscale 0.4];
      uicontrol('Style','frame','Units','norm','Pos',frmPos,'Back',ColorD);

      hndlList(10)=uicontrol(Std,'Style','text','Pos',[0.10,0.36,0.8,0.04],...
	'String',['Transfer function of W1(', num2str(ii),num2str(ii),')'],...
        'Back','b','Fore','r');

      uicontrol(Std,'Style','text','Pos',[0.16,0.11,0.28,0.05], ...
	'String','Transfer function form:','Back',ColorD,'Fore',ColorB);

      CallStr='W1=w1ui(''pzpoly'',W1_ii,W1);';

      hndlList(1)=uicontrol(Std,'Style','Popup','Pos',[0.17,0.06,0.26,0.05],...
	'Back',ColorB,'Fore',ColorA,'String',' poles & zeros | polynomials ',...
	'Value',W(ii,1)+1,'call',CallStr);

      % integrators
      uicontrol(Std,'Style','text','HorizontalAlignment','right', ...
	'Pos',[0.5,0.14,0.26,0.05],'String','No. integrators:',...
        'Back',ColorD,'Fore',ColorB);

      CallStr='W1=w1ui(''integrator'',W1_ii,W1);';
      hndlList(2)=uicontrol(Std,'Style','Popup','String','0|1|2|3|4|5|6',...
        'HorizontalAlignment','center','Pos',[.78 .14 .1 .05],...
        'Back',ColorB,'Fore',ColorA,'Value',W(ii,2)+1,'call',CallStr);

      %numerator order
      if(W(ii,1)),
         numStr='Numerator order:';
	 denStr='Denominator order:';
      else
	 numStr='No. zeros:';
	 denStr='No. poles:';
      end

      hndlList(3)=uicontrol(Std,'Style','text','HorizontalAlignment','right',...
        'Pos',[0.50,0.09,0.26,0.05],'String',numStr,...
        'Back',ColorD,'Fore',ColorB);

      CallStr='W1=w1ui(''numerator'',W1_ii,W1);';
      hndlList(4)=uicontrol(Std,'Style','Popup','String','0|1|2|3|4|5|6',...
        'HorizontalAlignment','center','Pos',[.78 .09 .1 .05],'Back',ColorB,...
	'Value',W(ii,3)+1,'call',CallStr);

      %denominator order
      hndlList(5)=uicontrol(Std,'Style','text','String',denStr,...
        'HorizontalAlignment','right', ...
	'Pos',[0.50,0.04,0.26,0.05],'Back',ColorD,'Fore',ColorB);

      CallStr='W1=w1ui(''denominator'',W1_ii,W1);';
      hndlList(6)=uicontrol(Std,'Style','Popup','String','0|1|2|3|4|5|6',...
        'HorizontalAlignment','center','Pos',[.78 .04 .1 .05],...
        'Back',ColorB,'Value',W(ii,4)+1,'call',CallStr);

      tfStr=wtfstr(W,ii);
      hndlList(7)=uicontrol(Std,'Style','text','Pos',[0.10,0.3,0.8,0.04], ...
	'String',deblank(tfStr(1,:)),...   
        'Back',ColorD,'Fore',ColorB,'Clipping','off');
      hndlList(8)=uicontrol(Std,'Style','text','Pos',[0.10,0.26,0.8,0.04],...
	'String',deblank(tfStr(2,:)),...
        'Back',ColorD,'Fore',ColorB,'Clipping','off');
      hndlList(9)=uicontrol(Std,'Style','text','Pos',[0.10,0.22,0.8,0.04], ...
        'String',deblank(tfStr(3,:)),...
        'Back',ColorD,'Fore',ColorB,'Clipping','off');

      uicontrol(Std,'Style','push','Pos',[.8 .9 .16 .07], ...
	'String','Load','call',[... 
        'hndlList=get(gcf,''UserData'');',...
        '[newmatfile, newpath] = uigetfile(''*_w1.mat'',''Load Weighting W1'');',...
        'if(newmatfile),',...
	'   fileStr=[newpath,newmatfile];',...
    	'   load(fileStr);',...
    	'   if(exist(''W1'')~=1), ',...
        '      msgtxt=[''Error in file '',fileStr,'' with matrix W1''];',...
        '      esmsg(msgtxt,''Error'',''error'');',...
        '   else,',...
        '      w1ui(''element'',hndlList(11),W1,length(W1(:,1))); ',...
        '   end,',...
        'else,',...
        '   esmsg([''Cannot load file'',fileStr],''Error'',''error'');',...
        'end']);

      uicontrol(Std,'Style','push','Pos',[.8 .79 .16 .07], ...
	'String','Save','call','w1ui(''save'',1,W1);');
      uicontrol(Std,'Style','push','Pos',[.8 .68 .16 .07], ...
	'String','Help','call','w1ui(''help'');');
      uicontrol(Std,'Style','push','Pos',[.8 .57 .16 .07], ...
	'String','Close','call','hndlList=get(gcf,''UserData'');close(gcf)');
      uicontrol(Std,'Style','push','Pos',[.8 .46 .16 .07], ...
	'String','OK','call',[...
        'tmp=sum(sum(W1(:,3:4)))+length(W1(:,1));',...
        'if exist(''W2''),',...
        '   tmp=tmp+sum(sum(W2(:,3:4)))+length(W2(:,1));',...
        '   tmpstr=[''Input the starting (1 x '',num2str(tmp),'')-vector''];',...
        '   set(findobj(''tag'',''ClConfigIn''),''String'',tmpstr);',...
        '   save w1w2tmp W1 W2,',...
        'end;',... 
        'close(gcf)']);

      % Now uncover the figure
      set(figNumber,'Visible','on','UserData',[hndlList,ii]);


  case 'element',
      hndlList=get(gcf,'UserData');
      tfStr=wtfstr(W,ii);
      set(hndlList(1),'Value',W(ii,1)+1);
      set(hndlList(2),'Value',W(ii,2)+1);
      set(hndlList(4),'Value',W(ii,3)+1);
      set(hndlList(6),'Value',W(ii,4)+1);
      set(hndlList(7),'String',deblank(tfStr(1,:)));
      set(hndlList(8),'String',deblank(tfStr(2,:)));
      set(hndlList(9),'String',deblank(tfStr(3,:)));
      set(hndlList(10),'String',...
         ['Transfer function of W1(', num2str(ii),num2str(ii),')']);
      if(W(ii,1)),
  	 numStr='Numerator order:';
	 denStr='Denominator order:';
      else
	 numStr='No. zeros:';
	 denStr='No. poles:';
      end
      set(hndlList(3),'String',numStr);
      set(hndlList(5),'String',denStr);


  case 'pzpoly',
      hndlList=get(gcf,'UserData');
      W(ii,1)=get(hndlList(1),'Value')-1;
      tfStr=wtfstr(W,ii);
      set(hndlList(7),'String',deblank(tfStr(1,:)));
      set(hndlList(8),'String',deblank(tfStr(2,:)));
      set(hndlList(9),'String',deblank(tfStr(3,:)));
      if(W(ii,1)),
	 numStr='Numerator order:';
	 denStr='Denominator order:';
      else
	 numStr='No. zeros:';
	 denStr='No. poles:';
      end
      set(hndlList(3),'String',numStr);
      set(hndlList(5),'String',denStr);


  case 'integrator',
      hndlList=get(gcf,'UserData');
      W(ii,2)=get(hndlList(2),'Value')-1;
      tfStr=wtfstr(W,ii);
      set(hndlList(7),'String',deblank(tfStr(1,:)));
      set(hndlList(8),'String',deblank(tfStr(2,:)));
      set(hndlList(9),'String',deblank(tfStr(3,:)));


  case 'numerator',
      hndlList=get(gcf,'UserData');
      W(ii,3)=get(hndlList(4),'Value')-1;
      tfStr=wtfstr(W,ii);
      set(hndlList(7),'String',deblank(tfStr(1,:)));
      set(hndlList(8),'String',deblank(tfStr(2,:)));
      set(hndlList(9),'String',deblank(tfStr(3,:)));


  case 'denominator',
      hndlList=get(gcf,'UserData');
      W(ii,4)=get(hndlList(6),'Value')-1;
      tfStr=wtfstr(W,ii);
      set(hndlList(7),'String',deblank(tfStr(1,:)));
      set(hndlList(8),'String',deblank(tfStr(2,:)));
      set(hndlList(9),'String',deblank(tfStr(3,:)));
    
   

  case 'save',             
      [newmatfile, newpath] = uiputfile('*_w1.mat', 'Save Weighting W1');
      if(newmatfile),
  	 fileStr=[newpath,newmatfile];W1=W;
         save(fileStr,'W1');
      end            


  case 'help',
      hlpStr= ...                                             
        [' This window allows you to configure the structure '
         ' of the weighting blocks before their parameters   '
         ' will have to be optimized.                        '
         '                                                   ' 
         ' File name: w1ui.m                                 '
         ' To Thanh Binh at 24-Oct-96                        '];
      eshlpfun('Help',hlpStr);                


end;    

