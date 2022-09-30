function guiclcfg(action)
% guiclcfg(action,Par1,Par2)
% create the GUI for configuration of the closed-loop system
%
% This function is not intended to call directly from users.
%
% See also DESIGN.M

% All Rights Reserved, 
% Revision 3.0, Oct. 1996
% Control System Design Toolbox 1993-96
% To Thanh Binh University of Magdeburg Germany 


% Get a good font for this platform.
[fname,fsize] = bestfont(computer);
Std.Units='norm';
Std.FontName=fname;
Std.FontSize=fsize;

mainfig_pos=get(findobj('tag','DesignMainFig'),'pos'); 
ssp=get(findobj('tag','DesignPlant'),'UserData');
ssp=ssp.dim;

figname='The closed-loop system with a ';
figure('units','pixels','pos',mainfig_pos,'NumberTitle','off','MenuBar','none',...
    'Color','w','Visible','off','tag','Closed-Loop');
xscale=.6;yscale=.79;
axes('DrawMode','fast','Units','norm','XTick',[],'YTick',[],...
     'XLim',[0 xscale],'YLim',[0 yscale], ...
     'Box','on','Pos',[.01 .2 xscale yscale],'Color',[.07,.5,.0]);

if ssp(1)>1,ModTxt=' Models';else, ModTxt=' Model';end
if ssp(3)>1,InTxt=' Inputs,';else, InTxt=' Input,';end
if ssp(4)>1,OutTxt=' Outputs';else, OutTxt=' Output';end

uicontrol('Style','frame','Units','norm','Pos',[.62 .19 .37 .79]);

uicontrol('Style','frame','Units','norm','Pos',[.01 .01 .6 .17]);
uicontrol(Std,'Style','text','Pos',[.02 .11 .58 .05],'HorizontalAlignment','left',...
    'string','Input the starting matrix ','tag','ClConfigIn');
value=uicontrol(Std,'Style','edit','Pos',[.02 .03 .58 .08],'string','','back','w');
uicontrol('Style','frame','Units','norm','Pos',[.62 .01 .37 .17]);
uicontrol(Std,'Style','push','Pos',[.67 .05 .12 .1],'String','Close',...
        'Call','close(gcf);');


switch action,
  case 'pi',
    uicontrol(Std,'Style','text','Pos',[.625 .8 .36 .1],...
       'string',' The design parameters are:','HorizontalAlignment','left');
    uicontrol(Std,'Style','text','Pos',[.625 .7 .36 .1],'string','x=[kP;kI]');

    uicontrol(Std,'Style','text','Pos',[.625 .6 .36 .1],'HorizontalAlignment','left',...
       'string',[' kP - (',num2str(ssp(3)),',',num2str(ssp(4)),')-matrix']);
    uicontrol(Std,'Style','text','Pos',[.625 .5 .36 .1],'HorizontalAlignment','left',...
       'string',[' kI - (',num2str(ssp(3)),',',num2str(ssp(4)),')-matrix']);

    uicontrol(Std,'Style','text','Pos',[.625 .32 .36 .08],'HorizontalAlignment','left',...
       'string','Informations about the plant:','fore','b');
    uicontrol(Std,'Style','text','Pos',[.625 .26 .36 .08],'HorizontalAlignment','left',...
       'string',['    ',num2str(ssp(1)),ModTxt]);
    uicontrol(Std,'Style','text','Pos',[.625 .21 .36 .08],'HorizontalAlignment','left',...
       'string',...
       ['    ',num2str(ssp(2)),' States,',num2str(ssp(3)),InTxt,num2str(ssp(4)),OutTxt]);

    set(findobj('tag','ClConfigIn'),'String',...
       ['Input the starting (',num2str(2*ssp(3)),',',num2str(ssp(4)),')-matrix']);
    Callback=[...
        'pl=get(gcf,''UserData'');',...
        'value=str2num(get(pl(1),''string''));',...
        'if size(value)==[2*pl(2),pl(3)],',...
        '   set(findobj(''tag'',''DesignStart''),''UserData'',{value,[]});',...
        '   close(gcf);',...
        'else,',...
        '   esmsg(''Dimension of x is not correctly!'',''Error'',''error'');',...
        'end'];

    set(gcf,'UserData',[value,ssp(3:4)],'name',[figname, 'PI-Controller']);


  case 'pid',
    uicontrol(Std,'Style','text','Pos',[.625 .8 .36 .1],...
       'string',' The design parameters are:','HorizontalAlignment','left');
    uicontrol(Std,'Style','text','Pos',[.625 .7 .36 .1],...
       'string','x=[s1,s2,s3,s4'']');

    uicontrol(Std,'Style','text','Pos',[.625 .6 .36 .1],'HorizontalAlignment','left',...
       'string',[' s1, s2, s3 - (',num2str(ssp(3)),',',num2str(ssp(4)),')-matrix']);
    uicontrol(Std,'Style','text','Pos',[.625 .5 .36 .1],'HorizontalAlignment','left',...
       'string',[' s4 - (',num2str(ssp(4)),',',num2str(ssp(3)),')-matrix']);
    uicontrol(Std,'Style','text','Pos',[.625 .32 .36 .08],'HorizontalAlignment','left',...
       'string','Informations about the plant:','fore','b');
    uicontrol(Std,'Style','text','Pos',[.625 .26 .36 .08],'HorizontalAlignment','left',...
       'string',['    ',num2str(ssp(1)),ModTxt]);
    uicontrol(Std,'Style','text','Pos',[.625 .21 .36 .08],'HorizontalAlignment','left',...
       'string',...
       ['    ',num2str(ssp(2)),' States,',num2str(ssp(3)),InTxt,num2str(ssp(4)),OutTxt]);


    Callback=[...
        'pl=get(gcf,''UserData'');',...
        'value=str2num(get(pl(1),''string''));',...
        'if size(value)==[pl(2),4*pl(3)],',...
        '   set(findobj(''tag'',''DesignStart''),''UserData'',{value,[]});',...
        '   close(gcf);',...
        'else,',...
        '   esmsg(''Dimension of x is not correctly!'',''Error'',''error'');',...
        'end'];

    set(findobj('tag','ClConfigIn'),'String',...
       ['Input the starting (',num2str(ssp(3)),',',num2str(4*ssp(4)),')-matrix']);

    set(gcf,'UserData',[value,ssp(3:4)],'name',[figname, 'PID-Controller']);


  case 'lqg',
    uicontrol(Std,'Style','text','Pos',[.625 .8 .36 .1],...
       'string',' The design parameters are:','HorizontalAlignment','left');
    uicontrol(Std,'Style','text','Pos',[.625 .7 .36 .1],'string','x=[Q,Rho]');

    uicontrol(Std,'Style','text','Pos',[.625 .6 .36 .1],'HorizontalAlignment','left',...
       'string',[' Q - a non-negative (1,',num2str(ssp(3)+ssp(4)),')-matrix']);
    uicontrol(Std,'Style','text','Pos',[.625 .5 .36 .1],'HorizontalAlignment','left',...
       'string',[' Rho - a  positive (1,2)-matrix']);

    uicontrol(Std,'Style','text','Pos',[.625 .32 .36 .08],'HorizontalAlignment','left',...
       'string','Informations about the plant:','fore','b');
    uicontrol(Std,'Style','text','Pos',[.625 .26 .36 .08],'HorizontalAlignment','left',...
       'string',['    ',num2str(ssp(1)),ModTxt]);
    uicontrol(Std,'Style','text','Pos',[.625 .21 .36 .08],'HorizontalAlignment','left',...
       'string',...
       ['    ',num2str(ssp(2)),' States,',num2str(ssp(3)),InTxt,num2str(ssp(4)),OutTxt]);


    Callback=[...
        'pl=get(gcf,''UserData'');',...
        'xstart=str2num(get(pl(1),''string''));',...
        'if length(xstart)==(2+pl(2)+pl(3)),',...
        '   if (xstart(1:pl(2)+pl(3)) >=0) & (xstart(1+pl(2)+pl(3):2+pl(2)+pl(3)) >0),',...
        '      xvalue={xstart,[zeros(1,pl(2)+pl(3)),1e-12,1e-12;1e+6*ones(1,pl(2)+pl(3)+2)]};',...
        '      set(findobj(''tag'',''DesignStart''),''UserData'',xvalue);',...
        '      close(gcf);',...
        '   else,',...
        '      esmsg(''Unsuitable values of x!'',''Error'',''error'');',...
        '   end,',...
        'else,',...
        '   esmsg(''Dimension of x is not correctly!'',''Error'',''error'');',...
        'end'];
    set(findobj('tag','ClConfigIn'),'String',...
       ['Input the starting (1,',num2str(ssp(3)+ssp(4)+2),')-matrix']);
    set(gcf,'UserData',[value,ssp(3:4)],'name',[figname, 'LQG-Controller']);


  case 'lsdp',
    arrow(.02, .6,.05,'r',.01,10,2,'y');
    uicontrol(Std,'Style','text','Pos',[.08 .75 .1 .1],'string','Kpre');
    arrow(.17,.6,.04,'r',.01,10,2,'y');
    theta=[0:.5:2]*pi;radius=.01;
    y_circ=.6+cos(theta)*radius*1.7;
    x_circ=0.22+sin(theta)*radius;
    line(x_circ,y_circ,'Color','y')
    arrow(.23,.6,.04,'r',.01,10,2,'y');
    uicontrol(Std,'Style','push','Pos',[.28 .75 .1 .1],...
       'string','W1','fore','r','call',[...
       'pl=get(gcf,''UserData'');set(pl(4),''Enable'',''on'');',...
       '[W1,W1_ii]=w1ui(''initialise'',[],[],pl(2));']);
    arrow(.37, .6,.05,'r',.01,10,2,'y');
    uicontrol(Std,'Style','text','Pos',[.43 .75 .1 .1],...
       'string','Plant');
    arrow(.52, .6,.07,'r',.01,10,2,'y');
    arrow(.56,.6,.3,'d',0,0,2,'y');
    arrow(.56,.3,.035 ,'l',.01,10,2,'y');
    w2hndl=uicontrol(Std,'Style','push','Pos',[.43 .45 .1 .1],...
       'string','W2','fore','r','Enable','off','call',[...
       'pl=get(gcf,''UserData'');',...
       '[W2,W2_ii]=w2ui(''initialise'',[],[],W1,pl(3));']);
    arrow(.42, .3,.045 ,'l',.01,10,2,'y');
    uicontrol(Std,'Style','text','Pos',[.28 .45 .1 .1],...
       'string','Kopt','call','');
    arrow(.28,.3,.06,'l',0,0,2,'y');
    arrow(.22,.3,.28,'u',.01,10,2,'y');


    uicontrol(Std,'Style','text','Pos',[.625 .9 .36 .08],...
       'string',' The design parameters:','HorizontalAlignment','left','fore','b');
    uicontrol(Std,'Style','text','Pos',[.625 .8 .36 .08],...
       'string','x=[W1,W2]');

    uicontrol(Std,'Style','text','Pos',[.625 .7 .36 .08],'HorizontalAlignment','left',...
       'string',[' W1, W2 are compensator weights']);

    uicontrol(Std,'Style','text','Pos',[.625 .32 .36 .08],'HorizontalAlignment','left',...
       'string','Informations about the plant:','fore','b');
    uicontrol(Std,'Style','text','Pos',[.625 .26 .36 .08],'HorizontalAlignment','left',...
       'string',['    ',num2str(ssp(1)),ModTxt]);
    uicontrol(Std,'Style','text','Pos',[.625 .21 .36 .08],'HorizontalAlignment','left',...
       'string',...
       ['    ',num2str(ssp(2)),' States,',num2str(ssp(3)),InTxt,num2str(ssp(4)),OutTxt]);

    Callback=[...
        'pl=get(gcf,''UserData'');',...
        'xstart=str2num(get(pl(1),''string''));',...
        'set(findobj(''tag'',''DesignStart''),''UserData'',{xstart,[]});',...
        'close(gcf)'];

    set(gcf,'UserData',[value,ssp(3:4),w2hndl],'name',[figname, 'LSDP-Controller']);


  case 'hinfn',
    arrow(.02,.35,.05,'r',.01,10,2,'y');
    theta=[0:.5:2]*pi;radius=.01;
    y_circ=.35+cos(theta)*radius*1.7;
    x_circ=0.08+sin(theta)*radius;
    line(x_circ,y_circ,'Color','y')
    arrow(.09,.35,.05,'r',.01,10,2,'y');
    uicontrol('Style','text','Units','norm','Pos',[.15 .5 .1 .1],'string','Hinf');
    arrow(.24,.35,.05,'r',.01,10,2,'y');
    uicontrol(Std,'Style','text','Pos',[.3 .5 .1 .1],'string','Plant');
    arrow(.39,.35,.05,'r',.01,10,2,'y');
    w2hndl=uicontrol(Std,'Style','push','Pos',[.45 .5 .1 .1],...
       'string','W2','fore','r','Enable','off','call',[...
       'pl=get(gcf,''UserData'');',...
       '[W2,W2_ii]=w2ui(''initialise'',[],[],W1,pl(3));']);
    arrow(.54,.35,.05,'r',.01,10,2,'y');
    arrow(.555,.35,.2,'d',0,0,2,'y');
    arrow(.555,.15,.405,'l',0,0,2,'y');
    arrow(.08,.15,.18,'u',.01,10,2,'y');

    uicontrol(Std,'Style','push','Pos',[.45 .8 .1 .1],...
       'string','W1','fore','r','call',[...
       'pl=get(gcf,''UserData'');set(pl(4),''Enable'',''on'');',...
       '[W1,W1_ii]=w1ui(''initialise'',[],[],pl(2));']);
    arrow(.1,.35,.3,'r',0,0,2,'y');
    arrow(.1,.65,.34,'r',.01,10,2,'y');
    arrow(.54,.65,.05,'r',.01,10,2,'y');

    uicontrol(Std,'Style','text','Pos',[.625 .9 .36 .08],...
       'string',' The design parameters:','HorizontalAlignment','left','fore','b');
    uicontrol(Std,'Style','text','Pos',[.625 .8 .36 .08],...
       'string','x=[W1,W2]');

    uicontrol(Std,'Style','text','Pos',[.625 .7 .36 .08],'HorizontalAlignment','left',...
       'string',[' W1, W2 are compensator weights']);

    uicontrol(Std,'Style','text','Pos',[.625 .32 .36 .08],'HorizontalAlignment','left',...
       'string','Informations about the plant:','fore','b');
    uicontrol(Std,'Style','text','Pos',[.625 .26 .36 .08],'HorizontalAlignment','left',...
       'string',['    ',num2str(ssp(1)),ModTxt]);
    uicontrol(Std,'Style','text','Pos',[.625 .21 .36 .08],'HorizontalAlignment','left',...
       'string',...
       ['    ',num2str(ssp(2)),' States,',num2str(ssp(3)),InTxt,num2str(ssp(4)),OutTxt]);

    Callback=[...
        'pl=get(gcf,''UserData'');',...
        'xstart=str2num(get(pl(1),''string''));',...
        'set(findobj(''tag'',''DesignStart''),''UserData'',{xstart,[]});',...
        'close(gcf)'];

    set(gcf,'UserData',[value,ssp(3:4),w2hndl],'name',[figname, 'Hinf-Controller']);

   case 'mu',
      error('Sorry, this controller is under development now!')

   case 'hinf',
      error('Sorry, this controller is under development now!')
end

uicontrol(Std,'Style','push','Pos',[.84 .05 .12 .1],'String','OK','Call',Callback);
set(gcf,'Visible','on');
