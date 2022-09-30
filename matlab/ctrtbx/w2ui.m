function [W,ii]=w2ui(action,ii,W,W1,nn)
% [W,ii]=w2ui(action,ii,W,W1,nn)	
%	User Interface to define Weighting function W2 details 
%
%	W(:,1)= flags for weighting 	0 : poles/zeros
%					1 : polynomials
%					2 : unity
%	W(:,2)= number of integrators
%	W(:,3)= numerator order
%	W(:,4)= denominator order
% Different to the weighting function W1, W2 has not a integrator, because it
% is seen like a high-pass filter (W1 is a low-pass filter)

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany


ColorA='k';
ColorB='w';
ColorC=[0.9,0.7,0.0];
ColorD='b';

if nargin<1,
    action='initialise';
end;

if nargin<2,ii=1;end
if nargin<3,W=zeros(ii,4);end
if nargin<4,W1=zeros(ii,4);end
nW1=sum(sum(W1(:,3:4)))+size(W1,1);

% Get a good font for this platform.
[fname,fsize] = bestfont(computer);
Std.Units='norm';
Std.FontName=fname;
Std.FontSize=fsize;


switch action,
   case 'initialise',
      if(~length(ii)),ii=1;end
      if(~length(W)),W=zeros(nn,4);end

      W=[W;zeros(nn-size(W,1),4)];
      figNumber=figure('Name','Weighting Function W2','NumberTitle','off', ...
        'MenuBar','none','Color',ColorA','Visible','off');

      xscale=.75;yscale=.56;
      axes('Units','norm','XTick',[],'YTick',[],'XLim',[0,1],'YLim',[0,1], ...
	'Box','on','XColor',ColorB,'YColor',ColorB,...
        'Pos',[0.01 0.43 xscale yscale],'Color',ColorC);

      %draw weighting matrix
      Wid=min(0.8,nn*0.15);xmid=0.5+0.01;
      wwid=min(0.8/nn,0.15)*xscale;
      wht=min(0.8/nn,0.15)*yscale;
      Wid2=Wid/2+0.02;
      if nn==1,
         text(xmid-Wid2-0.01,0.5,'W2 = ','HorizontalAlignment','right',...
             'FontName',fname,'FontSize',fsize);
	 xPos=0.01+(xmid-Wid/2)*xscale;
  	 yPos=0.99-(0.5-Wid/2)*yscale-wht;
  	 btnPos=[xPos yPos wwid wht];
	 uicontrol(Std,'Style','Push','Pos',btnPos,'Back',ColorB,'String','W2(11)','Call','');

      else
    	 text(xmid-Wid2-0.01,0.5,'W2 = ','HorizontalAlignment','right',...
             'FontName',fname,'FontSize',fsize);
    	 x=[xmid+0.01-Wid2,xmid-0.01+Wid2;xmid-Wid2,xmid+Wid2;
	    xmid-Wid2,xmid+Wid2;xmid+0.01-Wid2,xmid-0.01+Wid2;];
    	 y=[0.5-Wid2,0.5-Wid2;0.5-Wid2,0.5-Wid2;
	    0.5+Wid2,0.5+Wid2;0.5+Wid2,0.5+Wid2];
    	 line(x,y,'Color',ColorB)
	 for jj=1:nn,
	    xPos=0.01+(xmid-Wid/2)*xscale+(jj-1)*wwid;
	    yPos=0.99-(0.5-Wid/2)*yscale-jj*wht;
	    btnPos=[xPos yPos wwid wht];
	    uicontrol(Std,'Style','Push','Pos',btnPos,'Back',ColorB,...
               'String',['W2(',num2str(jj),num2str(jj),')'],'Call',...
               ['[W2,W2_ii]=w2ui(''element'',',num2str(jj),',W2,W1);']);
	 end
      end
      xscale=.98;

      %Define an element
      % The ELEMENT frame
      frmPos=[0.01 0.02 xscale 0.4];

      uicontrol('Style','frame','Units','norm','Pos',frmPos,'Back',ColorD);

      hndlList(10)=uicontrol(Std,'Style','text','Pos',[0.10,0.36,0.8,0.04], ...
	'String',['Transfer function of W2(', num2str(ii),num2str(ii),')'],...
        'Back','b','Fore','r');


      uicontrol(Std,'Style','text','Pos',[0.16,0.11,0.28,0.05], ...
        'String','Transfer function form:','Back',ColorD,'Fore',ColorB);

      hndlList(1)=uicontrol(Std,'Style','Popup','Pos',[0.17,0.06,0.26,0.05], ...
	'Back',ColorB,'String',' poles & zeros | polynomials | unity ',...
	'Value',W(ii,1)+1,'Call','W2=w2ui(''pzpoly'',W2_ii,W2,W1);');


      %numerator order
      if(W(ii,1)==0),
  	 numStr='No. zeros:';
	 denStr='No. poles:';
         VisStr='on';
      elseif(W(ii,1)==1),
	 numStr='Numerator order:';
	 denStr='Denominator order:';
         VisStr='on';
      elseif(W(ii,1)==2),
	 numStr='';
	 denStr='';
         VisStr='off';
      end

      hndlList(3)=uicontrol(Std,'Style','text','HorizontalAlignment','right', ...
	'Pos',[0.50,0.11,0.26,0.05],'String',numStr,'Back',ColorD,'Fore',ColorB);

      hndlList(4)=uicontrol(Std,'Style','Popup','Pos',[0.78,0.11,0.1,0.05], ...
	'Back',ColorB,'String','0|1|2|3|4|5|6','Value',W(ii,3)+1,...
	'Visible',VisStr,'Call','W2=w2ui(''numerator'',W2_ii,W2,W1);');

      %denominator order
      hndlList(5)=uicontrol(Std,'Style','text','HorizontalAlignment','right', ...
	'Pos',[0.50,0.06,0.26,0.06],'String',denStr,'Back',ColorD,'Fore',ColorB);
      hndlList(6)=uicontrol(Std,'Style','Popup','Pos',[0.78,0.06,0.1,0.05], ...
	'Back',ColorB,'String','0|1|2|3|4|5|6','Value',W(ii,4)+1,...
	'Visible',VisStr, 'Call','W2=w2ui(''denominator'',W2_ii,W2,W1);');
      tfStr=wtfstr(W,ii,nW1);
      hndlList(7)=uicontrol(Std,'Style','text','HorizontalAlignment','center', ...
	'Pos',[0.10,0.3,0.8,0.04],'String',deblank(tfStr(1,:)), ...
	'Back',ColorD,'Fore',ColorB,'Clipping','off');
      hndlList(8)=uicontrol(Std,'Style','text','HorizontalAlignment','center', ...
	'Pos',[0.10,0.26,0.8,0.04],'String',deblank(tfStr(2,:)), ...
	'Back',ColorD,'Fore',ColorB,'Clipping','off');
      hndlList(9)=uicontrol(Std,'Style','text','HorizontalAlignment','center', ...
	'Pos',[0.10,0.22,0.8,0.04], 'String',deblank(tfStr(3,:)), ...
	'Back',ColorD,'Fore',ColorB,'Clipping','off');

      uicontrol(Std,'Style','push','Pos',[.8 .9 .16 .07],'String','Load','call',[... 
        'hndlList=get(gcf,''UserData'');',...
        '[newmatfile,newpath]=uigetfile(''*_w2.mat'',''Load Weighting W2'');',...
        'if(newmatfile),',...
	'   fileStr=[newpath,newmatfile];',...
    	'   load(fileStr);',...
    	'   if(exist(''W2'')~=1), ',...
        '      esmsg([''Error in file '',fileStr,'' with matrix W2''],''Error'',''error'');',...
        '   else,',...
        '      w2ui(''element'',hndlList(11),W2,W1); ',...
        '   end,',...
        'else,',...
        '   esmsg([''Cannot load file'',fileStr],''Error'',''error'');',...
        'end']);

      uicontrol(Std,'Style','push','Pos',[.8 .79 .16 .07], ...
	'String','Save','call','w2ui(''save'',1,W2);');
      uicontrol(Std,'Style','push','Pos',[.8 .68 .16 .07], ...
	'String','Help','call','w2ui(''help'');');
      uicontrol(Std,'Style','push','Pos',[.8 .57 .16 .07], ...
	'String','Close','call','close(gcf)');
      uicontrol(Std,'Style','push','Pos',[.8 .46 .16 .07],'String','OK','call',[...
        'tmp=sum(sum(W1(:,3:4)))+length(W1(:,1))+sum(sum(W2(:,3:4)))+length(W2(:,1));',...
        'tmpstr=[''Input the starting (1 x '',num2str(tmp),'')-vector''];',...
        'set(findobj(''tag'',''ClConfigIn''),''String'',tmpstr);',...
        'save w1w2tmp W1 W2,',...
        'close(gcf)']);


      set(figNumber,'Visible','on','UserData',[hndlList, ii]);


  case 'element',
      hndlList=get(gcf,'UserData');
      tfStr=wtfstr(W,ii,nW1);
      set(hndlList(1),'Value',W(ii,1)+1);
      set(hndlList(7),'String',deblank(tfStr(1,:)));
      set(hndlList(8),'String',deblank(tfStr(2,:)));
      set(hndlList(9),'String',deblank(tfStr(3,:)));
      set(hndlList(10),'String',['Transfer function of W2(', num2str(ii),num2str(ii),')']);
      if(W(ii,1)==0),
	 numStr='No. zeros:';
	 denStr='No. poles:';
         set(hndlList(4),'Value',W(ii,3)+1,'Visible','on');
         set(hndlList(6),'Value',W(ii,4)+1,'Visible','on');
      elseif(W(ii,1)==1),
	 numStr='Numerator order:';
	 denStr='Denominator order:';
     	 set(hndlList(4),'Value',W(ii,3)+1,'Visible','on');
    	 set(hndlList(6),'Value',W(ii,4)+1,'Visible','on');
      elseif(W(ii,1)==2),
	 numStr='';
	 denStr='';
         set(hndlList(4),'Visible','off');
         set(hndlList(6),'Visible','off');
      end
      set(hndlList(3),'String',numStr);
      set(hndlList(5),'String',denStr);


  case 'pzpoly',
      hndlList=get(gcf,'UserData');
      W(ii,1)=get(hndlList(1),'Value')-1;
      tfStr=wtfstr(W,ii,nW1);
      set(hndlList(7),'String',deblank(tfStr(1,:)));
      set(hndlList(8),'String',deblank(tfStr(2,:)));
      set(hndlList(9),'String',deblank(tfStr(3,:)));
      if(W(ii,1)==0),
	 numStr='No. zeros:';
	 denStr='No. poles:';
         set(hndlList(4),'Value',W(ii,3)+1,'Visible','on');
         set(hndlList(6),'Value',W(ii,4)+1,'Visible','on');
      elseif(W(ii,1)==1),
	 numStr='Numerator order:';
	 denStr='Denominator order:';
    	 set(hndlList(4),'Value',W(ii,3)+1,'Visible','on');
    	 set(hndlList(6),'Value',W(ii,4)+1,'Visible','on');
      elseif(W(ii,1)==2),
	 numStr='';
	 denStr='';
         set(hndlList(4),'Visible','off');
         set(hndlList(6),'Visible','off');
      end
      set(hndlList(3),'String',numStr);
      set(hndlList(5),'String',denStr);


  case 'numerator',
      hndlList=get(gcf,'UserData');
      W(ii,3)=get(hndlList(4),'Value')-1;
      tfStr=wtfstr(W,ii,nW1);
      set(hndlList(7),'String',deblank(tfStr(1,:)));
      set(hndlList(8),'String',deblank(tfStr(2,:)));
      set(hndlList(9),'String',deblank(tfStr(3,:)));


  case 'denominator',
      hndlList=get(gcf,'UserData');
      W(ii,4)=get(hndlList(6),'Value')-1;
      tfStr=wtfstr(W,ii,nW1);
      set(hndlList(7),'String',deblank(tfStr(1,:)));
      set(hndlList(8),'String',deblank(tfStr(2,:)));
      set(hndlList(9),'String',deblank(tfStr(3,:)));

  case 'save',              
      [newmatfile, newpath] = uiputfile('*_w2.mat', 'Save Weighting W2');
      if(newmatfile),
	 fileStr=[newpath,newmatfile];W2=W;
      	 save(fileStr,'W2');
      end         


  case 'info',
      hlpStr= ...                                             
        [' This window allows you to configure the structure '
         ' of the weighting blocks before their parameters   '
         ' will have to be optimized.                        '
         '                                                   ' 
         ' File name: w2ui.m                                 '
         ' To Thanh Binh at 24-Oct-96                        '];
      eshlpfun('Help',hlpStr);                

end;    

